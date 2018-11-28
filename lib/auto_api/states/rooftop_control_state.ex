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
defmodule AutoApi.RooftopControlState do
  @moduledoc """
  Keeps RooftopControl state
  """

  @type convertible_roof_state ::
          :closed
          | :open
          | :emergency_locked
          | :closed_secured
          | :open_secured
          | :hard_top_mounted
          | :intermediate_position
          | :loading_position
          | :loading_position_immediate

  @type sunroof_tilt_state :: :closed | :tilted | :half_tilted
  @type sunroof_state :: :closed | :open | :intermediate

  @doc """
  RooftopControl state
  """
  defstruct dimming: nil,
            position: nil,
            convertible_roof_state: nil,
            sunroof_tilt_state: nil,
            sunroof_state: nil,
            timestamp: nil,
            property_timestamps: %{},
            properties: []

  use AutoApi.State, spec_file: "specs/rooftop_control.json"

  @type t :: %__MODULE__{
          dimming: nil | integer,
          position: nil | integer,
          convertible_roof_state: nil | convertible_roof_state,
          sunroof_tilt_state: nil | sunroof_tilt_state,
          sunroof_state: nil | sunroof_state,
          timestamp: DateTime.t() | nil,
          properties: list(atom)
        }

  @doc """
  Build state based on binary value

    iex> state_bin = <<0x01, 1::integer-16, 1>> <> <<0x02, 1::integer-16, 9>> <> <<0x03, 1::integer-16, 0x04>> <> <<0x04, 1::integer-16, 0x02>> <> <<0x05, 1::integer-16, 0x01>>
    iex> AutoApi.RooftopControlState.from_bin(state_bin)
    %AutoApi.RooftopControlState{dimming: 1, position: 9, convertible_roof_state: :open_secured, sunroof_tilt_state: :half_tilted, sunroof_state: :open}

  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> properties = [:dimming, :position, :convertible_roof_state, :sunroof_tilt_state]
    iex> AutoApi.RooftopControlState.to_bin(%AutoApi.RooftopControlState{dimming: 2, position: 9, convertible_roof_state: :open_secured, sunroof_tilt_state: :half_tilted, properties: properties})
    <<0x03, 1::integer-16, 0x04, 0x01, 1::integer-16, 2, 0x02, 1::integer-16, 9,  0x04, 1::integer-16, 0x02>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
