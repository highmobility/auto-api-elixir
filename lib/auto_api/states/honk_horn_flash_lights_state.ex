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
defmodule AutoApi.HonkHornFlashLightsState do
  @moduledoc """
  Keeps HonkHornFlashLights state
  """

  @type flashers ::
          :inactive | :emergency_flasher_active | :left_flasher_active | :right_flasher_active
  @doc """
  HonkHornFlashLights state
  """
  defstruct flashers: nil, properties: []

  use AutoApi.State, spec_file: "specs/honk_horn_flash_lights.json"

  @type t :: %__MODULE__{
          flashers: flashers | nil,
          properties: list(atom)
        }

  @doc """
  Build state based on binary value

  iex> AutoApi.HonkHornFlashLightsState.from_bin(<<0x01, 1::integer-16, 0x00>>)
  %AutoApi.HonkHornFlashLightsState{flashers: :inactive}

  iex> AutoApi.HonkHornFlashLightsState.from_bin(<<0x01, 1::integer-16, 0x01>>)
  %AutoApi.HonkHornFlashLightsState{flashers: :emergency_flasher_active}

  iex> AutoApi.HonkHornFlashLightsState.from_bin(<<0x01, 1::integer-16, 0x03>>)
  %AutoApi.HonkHornFlashLightsState{flashers: :right_flasher_active}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> AutoApi.HonkHornFlashLightsState.to_bin(%AutoApi.HonkHornFlashLightsState{flashers: :right_flasher_active, properties: [:flashers]})
    <<1, 0, 1, 3>>

    iex> AutoApi.HonkHornFlashLightsState.to_bin(%AutoApi.HonkHornFlashLightsState{flashers: :left_flasher_active, properties: [:flashers]})
    <<1, 0, 1, 2>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
