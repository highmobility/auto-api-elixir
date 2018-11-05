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
defmodule AutoApi.FirmwareVersionState do
  @moduledoc """
  Keeps Firmware Version state

  """

  @type car_sdk_version :: %{
          version_major: integer,
          version_minor: integer,
          version_patch: integer
        }

  @doc """
  Firmware Version state
  """
  defstruct car_sdk_version: nil,
            car_sdk_build_name: nil,
            application_version: nil,
            timestamp: nil,
            properties: []

  use AutoApi.State, spec_file: "specs/firmware_version.json"

  @type t :: %__MODULE__{
          car_sdk_version: car_sdk_version | nil,
          car_sdk_build_name: String.t() | nil,
          application_version: String.t() | nil,
          timestamp: DateTime.t() | nil,
          properties: list(atom)
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.FirmwareVersionState.from_bin(<<1, 0, 3, 12, 19, 1>>)
    %AutoApi.FirmwareVersionState{car_sdk_version: %{version_major: 12, version_minor: 19, version_patch: 1}}

    iex> AutoApi.FirmwareVersionState.from_bin(<<0x02, 20::integer-16>> <> "bmg-20180611.13-5623")
    %AutoApi.FirmwareVersionState{car_sdk_build_name: "bmg-20180611.13-5623"}

  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> properties = [:car_sdk_version]
    iex> AutoApi.FirmwareVersionState.to_bin(%AutoApi.FirmwareVersionState{properties: properties})
    <<>>

    iex> properties = [:car_sdk_version]
    iex> AutoApi.FirmwareVersionState.to_bin(%AutoApi.FirmwareVersionState{car_sdk_version: %{version_major: 12, version_minor: 19, version_patch: 0}, properties: properties})
    <<1, 0, 3, 12, 19, 0>>

    iex> AutoApi.FirmwareVersionState.to_bin(%AutoApi.FirmwareVersionState{car_sdk_build_name: "hello", properties: [:car_sdk_build_name]})
    <<2, 0, 5 >> <> "hello"

    iex> AutoApi.FirmwareVersionState.to_bin(%AutoApi.FirmwareVersionState{application_version: "V10", properties: [:application_version]})
    <<3, 0, 3>> <> "V10"
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
