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

  alias AutoApi.CommonData
  defstruct seat: [], properties: []

  use AutoApi.State, spec_file: "specs/seats.json"

  @type person_detected :: :not_detected | :detected
  @type seatbelt_fastened :: :not_fastened | :fastened
  @type seat_position :: :front_left | :front_right | :rear_right | :rear_left | :rear_center

  @type seat :: %{
          seat_position: seat_position,
          person_detected: person_detected,
          seatbelt_fastened: seatbelt_fastened
        }

  @type t :: %__MODULE__{
          seat: list(seat),
          properties: list(atom)
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.SeatsState.from_bin(<<0x01, 3::integer-16, 0x00, 0x01, 0x00>>)
    %AutoApi.SeatsState{seat: [%{person_detected: :detected, seat_position: :front_left, seatbelt_fastened: :not_fastened}]}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> seat = [%{person_detected: :not_detected, seat_position: :rear_center, seatbelt_fastened: :fastened}]
    iex> AutoApi.SeatsState.to_bin(%AutoApi.SeatsState{seat: seat, properties: [:seat]})
    <<1, 3::integer-16, 4, 0, 1>>

    iex> AutoApi.SeatsState.to_bin(%AutoApi.SeatsState{seat: [], properties: [:seat]})
    <<>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
