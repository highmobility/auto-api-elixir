# AutoAPI
# Copyright (C) 2018 High-Mobility GmbH
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see http://www.gnu.org/licenses/.
#
# Please inquire about commercial licensing options at
# licensing@high-mobility.com
defmodule AutoApi.GetAvailabilityCommand do
  @moduledoc """
  Abstraction for a `get_availability` command in AutoApi (id `0x02`).

  The `struct` contains two fields:

  * `capability` specifies the capability of the command as a Capability module
  * `properties` specifies which properties for which the availability is requested. An empty list indicates all properties.

  """

  @behaviour AutoApi.Command

  @version AutoApi.version()
  @identifier 0x02
  @name :get_availability

  @type properties :: list(AutoApi.Capability.property())

  @type t :: %__MODULE__{
          capability: AutoApi.Capability.t(),
          properties: properties(),
          version: AutoApi.version()
        }

  @enforce_keys [:capability, :properties]
  defstruct [:capability, :properties, version: @version]

  @doc """
  Returns the identifier of the command.

  # Example

  iex> #{__MODULE__}.identifier()
  0x02
  """
  @impl true
  @spec identifier() :: byte()
  def identifier(), do: @identifier

  @doc """
  Returns the name of the command.

  # Example

  iex> #{__MODULE__}.name()
  :get_availability
  """
  @impl true
  @spec name() :: AutoApi.Command.name()
  def name(), do: @name

  @doc """
  Creates a new GetAvailabilityCommand structure with the given `capability` and `properties`.

  # Example

      iex> capability = AutoApi.SeatsCapability
      iex> properties = [:persons_detected]
      iex> #{__MODULE__}.new(capability, properties)
      %#{__MODULE__}{capability: AutoApi.SeatsCapability, properties: [:persons_detected], version: 13}
  """
  @spec new(AutoApi.Capability.t(), properties()) :: t()
  def new(capability, properties) do
    %__MODULE__{capability: capability, properties: properties}
  end

  @doc """
  Returns the properties set in the command.

  If the command specifies all properties (that is, it is an empty list) it will return a list
  of the state properties as by the specifications of the capability.

  ## Examples

      iex> command = #{__MODULE__}.new(AutoApi.RaceCapability, [:vehicle_moving, :gear_mode])
      iex> #{__MODULE__}.properties(command)
      [:vehicle_moving, :gear_mode]

      iex> command = #{__MODULE__}.new(AutoApi.HoodCapability, [])
      iex> #{__MODULE__}.properties(command)
      [:position, :lock, :lock_safety, :nonce, :vehicle_signature, :timestamp, :vin, :brand]
  """
  @impl true
  @spec properties(t()) :: list(AutoApi.Capability.property())
  def properties(%__MODULE__{capability: capability, properties: properties}) do
    case properties do
      [] -> capability.state_properties()
      properties -> properties
    end
  end

  @doc """
  Transforms a GetAvailabilityCommand struct into a binary format.

  If the command is somehow invalid, it returns an error.

  # Examples

  iex> # Request the door locks state availability
  iex> command = %#{__MODULE__}{capability: AutoApi.DoorsCapability, properties: [:locks_state]}
  iex> #{__MODULE__}.to_bin(command)
  <<13, 0, 32, 2, 6>>

  iex> # Request all properties availability for race state
  iex> command = %#{__MODULE__}{capability: AutoApi.RaceCapability, properties: []}
  iex> #{__MODULE__}.to_bin(command)
  <<13, 0, 87, 2>>
  """
  @impl true
  @spec to_bin(t()) :: binary()
  def to_bin(%__MODULE__{capability: capability, properties: properties}) do
    preamble = <<@version, capability.identifier()::binary, @identifier>>

    Enum.reduce(properties, preamble, &(&2 <> <<capability.property_id(&1)::8>>))
  end

  @doc """
  Parses a command binary and returns a GetAvailabilityCommand struct

  ## Examples

      iex> #{__MODULE__}.from_bin(<<0x0D, 0x00, 0x33, 0x02, 0x01, 0x04>>)
      %#{__MODULE__}{capability: AutoApi.DiagnosticsCapability, properties: [:mileage, :engine_rpm], version: 13}
  """
  @impl true
  @spec from_bin(binary) :: t()
  def from_bin(<<@version, capability_id::binary-size(2), @identifier, properties::binary>>) do
    capability = AutoApi.Capability.get_by_id(capability_id)

    property_names =
      properties
      |> :binary.bin_to_list()
      |> Enum.map(&capability.property_name/1)

    new(capability, property_names)
  end
end
