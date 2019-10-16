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
defmodule AutoApi.VideoHandoverState do
  @moduledoc """
  VideoHandover state
  """

  alias AutoApi.PropertyComponent

  defstruct url: nil,
            starting_second: nil,
            screen: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/video_handover.json"

  @type t :: %__MODULE__{
          url: %PropertyComponent{data: String.t()} | nil,
          starting_second: %PropertyComponent{data: String.t()} | nil,
          screen: %PropertyComponent{data: String.t()} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> url = "https://vimeo.com/365286467"
    iex> size = byte_size(url)
    iex> AutoApi.VideoHandoverState.from_bin(<<1, size + 3::integer-16, 1, size::integer-16, url::binary>>)
    %AutoApi.VideoHandoverState{url: %AutoApi.PropertyComponent{data: "https://vimeo.com/365286467"}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> url = "https://vimeo.com/365286467"
    iex> state = %AutoApi.VideoHandoverState{url: %AutoApi.PropertyComponent{data: url}}
    iex> AutoApi.VideoHandoverState.to_bin(state)
    <<1, 30::integer-16, 1, 27::integer-16, 0x68, 0x74, 0x74, 0x70, 0x73, 0x3A, 0x2F, 0x2F, 0x76, 0x69, 0x6D, 0x65, 0x6F, 0x2E, 0x63, 0x6F, 0x6D, 0x2F, 0x33, 0x36, 0x35, 0x32, 0x38, 0x36, 0x34, 0x36, 0x37>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
