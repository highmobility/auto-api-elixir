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

  @type command :: GetAvailabilityCommand.t() | GetCommand.t() | SetCommand.t()

  @callback identifier :: byte()
  @callback to_bin(command()) :: binary()
  @callback from_bin(binary()) :: command()

  @version AutoApi.version()

  @doc """
  Parses a binary command and returns a struct with the command data.

  The struct type determines the command action, and further data is contained in the struct fields themselves.

  Possible result types are:

  * AutoApi.GetAvailabilityCommand
  * AutoApi.GetCommand
  * AutoApi.SetCommand

  See the documentation for each module to understand what their fields stand for.

  ## Examples

      iex> #{__MODULE__}.from_bin(<<0x0C, 0x00, 0x33, 0x02, 0x01, 0x04>>)
      %AutoApi.GetAvailabilityCommand{capability: AutoApi.DiagnosticsCapability, properties: [:mileage, :engine_rpm]}

      iex> #{__MODULE__}.from_bin(<<0x0C, 0x00, 0x33, 0x00, 0x01, 0x04>>)
      %AutoApi.GetCommand{capability: AutoApi.DiagnosticsCapability, properties: [:mileage, :engine_rpm]}

      iex> # Parses a "lock vehicle doors" command
      iex> #{__MODULE__}.from_bin(<<12, 0, 32, 1, 6, 0, 4, 1, 0, 1, 1>>)
      %AutoApi.SetCommand{capability: AutoApi.DoorsCapability, state: %AutoApi.DoorsState{locks_state: %AutoApi.Property{data: :locked}}}
  """
  @spec from_bin(binary()) :: command()
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
end
