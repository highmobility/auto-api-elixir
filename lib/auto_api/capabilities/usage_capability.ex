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
defmodule AutoApi.UsageCapability do
  @moduledoc """
  Basic settings for usage Capability

      iex> alias AutoApi.UsageCapability, as: U
      iex> U.identifier
      <<0x00, 0x68>>
      iex> U.name
      :usage
      iex> U.description
      "Usage"
      iex> U.command_name(0x00)
      :get_usage
      iex> U.command_name(0x01)
      :usage
      iex> length(U.properties)
      0x0E
  """

  @spec_file "specs/usage.json"
  @type command_type :: :get_usage | :usage

  @command_module AutoApi.NotImplemented
  @state_module AutoApi.UsageState

  use AutoApi.Capability
end
