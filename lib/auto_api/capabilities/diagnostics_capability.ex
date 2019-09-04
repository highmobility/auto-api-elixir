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
defmodule AutoApi.DiagnosticsCapability do
  @moduledoc """
  Basic settings for Diagnostics Capability

      iex> alias AutoApi.DiagnosticsCapability, as: D
      iex> D.identifier
      <<0x00, 0x33>>
      iex> D.name
      :diagnostics
      iex> D.description
      "Diagnostics"
      iex> length(D.properties)
      27
  """

  @type command_type :: :get_diagnostics_state | :diagnostics_state

  @command_module AutoApi.DiagnosticsCommand
  @state_module AutoApi.DiagnosticsState

  use AutoApi.Capability, spec_file: "specs/diagnostics.json"
end
