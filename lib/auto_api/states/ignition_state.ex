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
defmodule AutoApi.IgnitionState do
  @moduledoc """
  Keeps Ignition state
  """

  alias AutoApi.PropertyComponent

  @type on_off :: :on | :off

  @type t :: %__MODULE__{
          ignition: %PropertyComponent{data: on_off} | nil,
          accessories_ignition: %PropertyComponent{data: on_off} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Ignition state
  """
  defstruct ignition: nil,
            accessories_ignition: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/ignition.json"

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 0>>
    iex> AutoApi.IgnitionState.from_bin(bin)
    %AutoApi.IgnitionState{ignition: %AutoApi.PropertyComponent{data: :off}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> state = %AutoApi.IgnitionState{ignition: %AutoApi.PropertyComponent{data: :off}}
    iex> AutoApi.IgnitionState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 0>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
