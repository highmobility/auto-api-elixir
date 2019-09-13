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
defmodule AutoApi.WakeUpState do
  @moduledoc """
  WakeUp state
  """

  alias AutoApi.{CommonData, PropertyComponent}

  defstruct wake_up: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/wake_up.json"

  @type t :: %__MODULE__{
          wake_up: %PropertyComponent{data: :wake_up} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 0>>
    iex> AutoApi.WakeUpState.from_bin(bin)
    %AutoApi.WakeUpState{wake_up: %AutoApi.PropertyComponent{data: :wake_up}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.WakeUpState{wake_up: %AutoApi.PropertyComponent{data: :wake_up}}
    iex> AutoApi.WakeUpState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 0>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
