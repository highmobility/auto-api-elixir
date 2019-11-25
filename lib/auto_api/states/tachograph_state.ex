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
defmodule AutoApi.TachographState do
  @moduledoc """
  Keeps Tachograph state

  """

  alias AutoApi.PropertyComponent

  @doc """
  Tachograph state
  """
  defstruct drivers_working_states: [],
            drivers_time_states: [],
            drivers_cards_present: [],
            vehicle_motion: nil,
            vehicle_overspeed: nil,
            vehicle_direction: nil,
            vehicle_speed: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/tachograph.json"

  @type vehicle_motion :: :not_detected | :detected
  @type vehicle_overspeed :: :no_overspeed | :overspeed
  @type vehicle_direction :: :forward | :reverse
  @type working_state :: :resting | :driver_available | :working | :driving
  @type time_state ::
          :normal
          | :fifteen_min_before_four
          | :four_reached
          | :fifteen_min_before_nine
          | :nine_reached
          | :fifteen_min_before_sixteen
          | :sixteen_reached
  @type card_present :: :not_present | :present
  @type driver_working_state :: %PropertyComponent{
          data: %{working_state: working_state, driver_number: integer}
        }
  @type driver_time_state :: %PropertyComponent{
          data: %{time_state: time_state, driver_number: integer}
        }
  @type drivers_cards_present :: %PropertyComponent{
          data: %{card_present: card_present, driver_number: integer}
        }

  @type t :: %__MODULE__{
          drivers_working_states: list(driver_working_state),
          drivers_time_states: list(driver_time_state),
          drivers_cards_present: list(drivers_cards_present),
          vehicle_motion: %PropertyComponent{data: vehicle_motion} | nil,
          vehicle_overspeed: %PropertyComponent{data: vehicle_overspeed} | nil,
          vehicle_direction: %PropertyComponent{data: vehicle_direction} | nil,
          vehicle_speed: %PropertyComponent{data: integer} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<4, 0, 4, 1, 0, 1, 1>>
    iex> AutoApi.TachographState.from_bin(bin)
    %AutoApi.TachographState{vehicle_motion: %AutoApi.PropertyComponent{data: :detected}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> state = %AutoApi.TachographState{vehicle_motion: %AutoApi.PropertyComponent{data: :detected}}
    iex> AutoApi.TachographState.to_bin(state)
    <<4, 0, 4, 1, 0, 1, 1>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
