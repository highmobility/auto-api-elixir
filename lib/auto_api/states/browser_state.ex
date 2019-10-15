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
defmodule AutoApi.BrowserState do
  @moduledoc """
  Browser state
  """

  alias AutoApi.{CommonData, PropertyComponent}

  defstruct url: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/browser.json"

  @type t :: %__MODULE__{
          url: %PropertyComponent{data: String.t()} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> url = "https://about.high-mobility.com"
    iex> size = byte_size(url)
    iex> AutoApi.BrowserState.from_bin(<<1, size + 3::integer-16, 1, size::integer-16, url::binary>>)
    %AutoApi.BrowserState{url: %AutoApi.PropertyComponent{data: "https://about.high-mobility.com"}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> url = "https://about.high-mobility.com"
    iex> state = %AutoApi.BrowserState{url: %AutoApi.PropertyComponent{data: url}}
    iex> AutoApi.BrowserState.to_bin(state)
    <<1, 34::integer-16, 1, 31::integer-16, 0x68, 0x74, 0x74, 0x70, 0x73, 0x3A, 0x2F, 0x2F, 0x61, 0x62, 0x6F, 0x75, 0x74, 0x2E, 0x68, 0x69, 0x67, 0x68, 0x2D, 0x6D, 0x6F, 0x62, 0x69, 0x6C, 0x69, 0x74, 0x79, 0x2E, 0x63, 0x6F, 0x6D>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
