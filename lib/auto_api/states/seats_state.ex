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
defmodule AutoApi.SeatsState do
  @moduledoc """
  Seats state
  """

  alias AutoApi.PropertyComponent

  defstruct persons_detected: [],
            seatbelts_fastened: [],
            timestamp: nil,
            properties: [],
            property_timestamps: %{}

  use AutoApi.State, spec_file: "specs/seats.json"

  @type seat_location :: :front_left | :front_right | :rear_right | :rear_left | :rear_center
  @type person_detected :: :detected | :not_detected
  @type persons_detected :: %PropertyComponent{
          data: %{seat_location: seat_location, person_detected: person_detected}
        }
  @type seatbelt_fastened :: :not_fastened | :fastened
  @type seatbelts_fastened :: %PropertyComponent{
          data: %{seat_location: seat_location, seatbelt_fastened: seatbelt_fastened}
        }

  @type t :: %__MODULE__{
          persons_detected: list(persons_detected),
          seatbelts_fastened: list(seatbelts_fastened),
          timestamp: DateTime.t() | nil,
          properties: list(atom),
          property_timestamps: map()
        }

  @doc """
  Build state based on binary value

    iex> bin = <<2, 0, 5, 1, 0, 2, 4, 1>>
    iex> AutoApi.SeatsState.from_bin(bin)
    %AutoApi.SeatsState{persons_detected: [%AutoApi.PropertyComponent{data: %{seat_location: :rear_center, person_detected: :detected}}]}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.SeatsState{persons_detected: [%AutoApi.PropertyComponent{data: %{seat_location: :rear_center, person_detected: :detected}}], properties: [:persons_detected]}
    iex> AutoApi.SeatsState.to_bin(state)
    <<2, 0, 5, 1, 0, 2, 4, 1>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
