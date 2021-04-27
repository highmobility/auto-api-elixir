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
defmodule AutoApiL12.LegacyCommand do
  @moduledoc """
  This module is only intended to provide a compatibility layer for code that relies
  on the removed per-capability command modules.
  """

  @doc """
  Converts a state structure into a set command binary message.

  # Example

      iex> state =  %AutoApiL12.EngineState{status: %AutoApiL12.Property{data: :on}}
      iex> #{__MODULE__}.state(state)
      <<12, 0, 105, 1, 1, 0, 4, 1, 0, 1, 1>>
  """
  @spec state(AutoApiL12.State.t()) :: binary()
  def state(state) do
    state |> AutoApiL12.SetCommand.new() |> AutoApiL12.SetCommand.to_bin()
  end
end
