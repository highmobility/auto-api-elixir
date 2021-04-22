# AutoAPI
# The MIT License
#
# Copyright (c) 2018- High-Mobility GmbH (https://high-mobility.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
defmodule AutoApi.Command do
  @moduledoc """
  Command behavior for handling AutoApi commands
  """

  alias AutoApi.{GetAvailabilityCommand, GetCommand, SetCommand}

  @type t :: GetAvailabilityCommand.t() | GetCommand.t() | SetCommand.t()
  @type name :: :get | :get_availability | :set

  @callback identifier :: byte()
  @callback name :: name()
  @callback properties(t()) :: list(AutoApi.Capability.property())
  @callback to_bin(t()) :: binary()
  @callback from_bin(binary()) :: t()

  @commands [GetAvailabilityCommand, GetCommand, SetCommand]
  @version AutoApi.version()

  @doc """
  Returns the identifier of the command

  # Example

  iex> command = AutoApi.GetAvailabilityCommand.new(AutoApi.DiagnosticsCapability, [])
  iex> AutoApi.Command.identifier(command)
  0x02
  """
  @spec identifier(t()) :: identifier()
  def identifier(%command_module{}) when command_module in @commands do
    command_module.identifier()
  end

  @doc """
  Returns the name of the command

  # Example

  iex> command = AutoApi.GetAvailabilityCommand.new(AutoApi.DiagnosticsCapability, [])
  iex> AutoApi.Command.name(command)
  :get_availability
  """
  @spec name(t()) :: name()
  def name(%command_module{}) when command_module in @commands do
    command_module.name()
  end

  @doc """
  Returns the properties set in the command.

  For Get and GetAvailability commands, it returns the list of properties in the command, or
  all the state properties if the list is empty.

  For SetCommands, it returns the list of properties with anything set in them

  # Examples

      iex> command = AutoApi.GetAvailabilityCommand.new(AutoApi.HoodCapability, [])
      iex> #{__MODULE__}.properties(command)
      [:position, :lock, :lock_safety, :nonce, :vehicle_signature, :timestamp, :vin, :brand]

      iex> command = AutoApi.GetCommand.new(AutoApi.HoodCapability, [])
      iex> #{__MODULE__}.properties(command)
      [:position, :lock, :lock_safety, :nonce, :vehicle_signature, :timestamp, :vin, :brand]

      iex> state = AutoApi.RaceState.base()
      ...>         |> AutoApi.State.put(:vehicle_moving, data: :sport, timestamp: ~U[2021-03-12 10:54:14Z])
      ...>         |> AutoApi.State.put(:brake_torque_vectorings, data: %{axle: :front, state: :active})
      iex> command = AutoApi.SetCommand.new(state)
      iex> #{__MODULE__}.properties(command)
      [:brake_torque_vectorings, :vehicle_moving]
  """
  @spec properties(t()) :: list(AutoApi.Capability.property())
  def properties(%command_module{} = command) when command_module in @commands do
    command_module.properties(command)
  end

  @doc """
  Parses a binary command and returns a struct with the command data.

  The struct type determines the command action, and further data is contained in the struct fields themselves.

  Possible result types are:

  * AutoApi.GetAvailabilityCommand
  * AutoApi.GetCommand
  * AutoApi.SetCommand

  See the documentation for each module to understand what their fields stand for.

  ## Examples

      iex> #{__MODULE__}.from_bin(<<0x0D, 0x00, 0x33, 0x02, 0x01, 0x04>>)
      %AutoApi.GetAvailabilityCommand{capability: AutoApi.DiagnosticsCapability, properties: [:mileage, :engine_rpm]}

      iex> #{__MODULE__}.from_bin(<<0x0D, 0x00, 0x33, 0x00, 0x01, 0x04>>)
      %AutoApi.GetCommand{capability: AutoApi.DiagnosticsCapability, properties: [:mileage, :engine_rpm]}

      iex> # Parses a "lock vehicle doors" command
      iex> #{__MODULE__}.from_bin(<<13, 0, 32, 1, 6, 0, 4, 1, 0, 1, 1>>)
      %AutoApi.SetCommand{capability: AutoApi.DoorsCapability, state: %AutoApi.DoorsState{locks_state: %AutoApi.Property{data: :locked}}}
  """
  @spec from_bin(binary()) :: t()
  def from_bin(<<@version, _cap_id::binary-size(2), action, _::binary>> = bin_command) do
    get_availability_command_id = GetAvailabilityCommand.identifier()
    get_command_id = AutoApi.GetCommand.identifier()
    set_command_id = AutoApi.SetCommand.identifier()

    case action do
      ^get_availability_command_id -> AutoApi.GetAvailabilityCommand.from_bin(bin_command)
      ^get_command_id -> AutoApi.GetCommand.from_bin(bin_command)
      ^set_command_id -> AutoApi.SetCommand.from_bin(bin_command)
    end
  end

  @doc """
  Parses a command and returns it in binary format.

  This is a convenience function that only delegates to the `to_bin/1` function of the command module.

  ## Examples

  iex> # Request all properties for race state
  iex> command = %AutoApi.GetAvailabilityCommand{capability: AutoApi.RaceCapability, properties: []}
  iex> #{__MODULE__}.to_bin(command)
  <<13, 0, 87, 2>>

  iex> # Request the door locks state
  iex> command = %AutoApi.GetCommand{capability: AutoApi.DoorsCapability, properties: [:locks_state]}
  iex> #{__MODULE__}.to_bin(command)
  <<13, 0, 32, 0, 6>>

  iex> # Request to honk the horn for 2.5 seconds
  iex> capability = AutoApi.HonkHornFlashLightsCapability
  iex> honk_time = %{value: 2.5, unit: :seconds}
  iex> state = AutoApi.State.put(capability.state().base(), :honk_time, data: honk_time)
  iex> command = %AutoApi.SetCommand{capability: capability, state: state}
  iex> #{__MODULE__}.to_bin(command)
  <<13, 0, 38, 1, 5, 0, 13, 1, 0, 10, 7, 0, 64, 4, 0, 0, 0, 0, 0, 0>>
  """
  @spec to_bin(t()) :: binary()
  def to_bin(%command_mod{} = command) when command_mod in @commands do
    command_mod.to_bin(command)
  end
end
