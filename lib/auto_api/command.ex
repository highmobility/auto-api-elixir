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

  alias AutoApi.Capability

  @type capability_name :: atom()
  @type action :: atom()
  @type data :: any()
  @type get_properties :: list(atom)
  @type set_properties :: keyword(AutoApi.Property.t() | data())

  defmacro __using__(_opts) do
    capability =
      __CALLER__.module
      |> Atom.to_string()
      |> String.replace(~r/Command$/, "Capability")
      |> String.to_atom()

    AutoApi.Command.Meta.inject_command_code(capability)
  end

  @callback execute(struct, binary) :: struct
  @callback state(struct) :: binary

  @version AutoApi.version()

  @doc """
  Extracts commands meta data  including the capability that
  the command is using and exact command that is issued

      iex> AutoApi.Command.meta_data(<<0x0C, 0x00, 0x33, 0x00>>)
      %{message_id: :diagnostics, message_type: :get, module: AutoApi.DiagnosticsCapability, version: 0x0C, properties: []}

      iex> AutoApi.Command.meta_data(<<0x0C, 0x00, 0x33, 0x02>>)
      %{message_id: :diagnostics, message_type: :get_availability, module: AutoApi.DiagnosticsCapability, version: 0x0C, properties: []}

      iex> AutoApi.Command.meta_data(<<0x0C, 0x00, 0x57, 0x00, 0x0B, 0x0C>>)
      %{message_id: :race, message_type: :get, module: AutoApi.RaceCapability, version: 0x0C, properties: [:gear_mode, :selected_gear]}

      iex> binary_command = <<0x0C, 0x00, 0x23, 0x1, 0x17, 0x00, 0x04, 0x01, 0x00, 0x01, 0x08>>
      iex> AutoApi.Command.meta_data(binary_command)
      %{message_id: :charging, message_type: :set, module: AutoApi.ChargingCapability, version: 0x0C, properties: [status: %AutoApi.Property{data: :fast_charging}]}
  """
  @spec meta_data(binary) :: map()
  def meta_data(<<@version, id::binary-size(2), _::binary>> = command_bin) do
    with capability_module when not is_nil(capability_module) <- Capability.get_by_id(id),
         capability_name <- capability_module.name(),
         {command_name, properties} <- capability_module.command().from_bin(command_bin) do
      %{
        message_id: capability_name,
        message_type: command_name,
        module: capability_module,
        version: AutoApi.version(),
        properties: properties
      }
    else
      nil ->
        %{}
    end
  end

  @doc """
  Converts the command to the binary format.

  The command action can be `:get`, ':get_availability', `:set` or one of the setters of the capability.

  In case the action is `:set` or one of the capability setter, the `properties`
  must be a keyword list with the property name as key and a
  `AutoApi.Property` struct as value.

  It is also permitted, as a shorthand notation, to forego the `Property`
  struct "wrapper" and pass directly the property value. In this case however
  it is not possible to specify the property timestamp nor a failure.

  ## Examples

      iex> AutoApi.Command.to_bin(:diagnostics, :get, [:mileage, :engine_rpm])
      <<0x0C, 0x00, 0x33, 0x00, 0x01, 0x04>>

      iex> AutoApi.Command.to_bin(:diagnostics, :get_availability, [:mileage, :engine_rpm])
      <<0x0C, 0x00, 0x33, 0x02, 0x01, 0x04>>

      iex> prop = %AutoApi.Property{data: %{value: 88, unit: :miles_per_hour}, timestamp: ~U[2019-07-18 13:58:40.489250Z]}
      iex> AutoApi.Command.to_bin(:diagnostics, :set, speed: prop)
      <<12, 0, 51, 1, 3, 0, 24, 1, 0, 10, 22, 2, 64, 86, 0, 0, 0, 0, 0, 0, 2, 0, 8, 0, 0, 1, 108, 5, 96, 184, 105>>

      iex> AutoApi.Command.to_bin(:charging, :set_charge_limit, charge_limit: 0.8)
      <<0x0C, 0, 35, 1, 8, 0, 11, 1, 0, 8, 63, 233, 153, 153, 153, 153, 153, 154>>

  """
  @spec to_bin(capability_name, action, get_properties | set_properties) :: binary
  def to_bin(capability_name, action, properties) do
    capability = Capability.get_by_name(capability_name)

    capability.command.to_bin(action, properties)
  end
end
