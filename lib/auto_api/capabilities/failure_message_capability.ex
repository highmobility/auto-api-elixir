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
defmodule AutoApi.FailureMessageCapability do
  @moduledoc """
  Basic settings for FailureMessage Capability

      iex> alias AutoApi.FailureMessageCapability, as: F
      iex> F.identifier
      <<0x00, 0x2>>
      iex> F.name
      :failure_message
      iex> F.description
      "Failure Message"
      iex> length(F.properties)
      5
      iex> List.last(F.properties)
      {5, :failed_property_ids}
  """

  @type command_type :: :failure_message | :failure

  @command_module AutoApi.FailureMessageCommand
  @state_module AutoApi.FailureMessageState

  use AutoApi.Capability, spec_file: "specs/failure_message.json"
end
