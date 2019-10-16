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
defmodule AutoApi.HeartRateState do
  @moduledoc """
  HeartRate state
  """

  alias AutoApi.{CommonData, PropertyComponent}

  defstruct heart_rate: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/heart_rate.json"

  @type t :: %__MODULE__{
          heart_rate: %PropertyComponent{data: integer} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.HeartRateState.from_bin(<<1, 4::integer-16, 1, 1::integer-16, 80>>)
    %AutoApi.HeartRateState{heart_rate: %AutoApi.PropertyComponent{data: 80}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.HeartRateState{heart_rate: %AutoApi.PropertyComponent{data: 80}}
    iex> AutoApi.HeartRateState.to_bin(state)
    <<1, 4::integer-16, 1, 1::integer-16, 80>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
