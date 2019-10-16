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
defmodule AutoApi.GraphicsCapability do
  @moduledoc """
  Basic settings for Graphics Capability

      iex> alias AutoApi.GraphicsCapability, as: G
      iex> G.identifier
      <<0x00, 0x51>>
      iex> G.name
      :graphics
      iex> G.description
      "Graphics"
      iex> length(G.properties)
      1
  """

  @command_module AutoApi.GraphicsCommand
  @state_module AutoApi.GraphicsState

  use AutoApi.Capability, spec_file: "specs/graphics.json"
end
