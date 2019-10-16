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
defmodule AutoApi.HistoricalStateTest do
  use ExUnit.Case
  doctest AutoApi.HistoricalState

  alias AutoApi.{ChargingCapability, ChargingState, HistoricalState, PropertyComponent}

  # TODO
  @tag :skip
  test "from_bin/1 and to_bin/1" do
    states = [
      %PropertyComponent{
        data: %ChargingState{battery_level: %PropertyComponent{data: 0.6}},
        timestamp: ~U[2019-10-16 12:34:04Z]
      },
      %PropertyComponent{
        data: %ChargingState{battery_level: %PropertyComponent{data: 0.75}},
        timestamp: ~U[2019-10-16 13:34:04Z]
      },
      %PropertyComponent{
        data: %ChargingState{battery_level: %PropertyComponent{data: 0.89}},
        timestamp: ~U[2019-10-16 14:34:04Z]
      }
    ]

    state = %HistoricalState{
      states: states,
      capability_id: %PropertyComponent{data: ChargingCapability.identifier()},
      start_date: %PropertyComponent{data: ~U[2019-10-16 12:34:04Z]},
      end_date: %PropertyComponent{data: ~U[2019-10-16 14:34:04Z]}
    }

    restored_state =
      state
      |> HistoricalState.to_bin()
      |> HistoricalState.from_bin()

    assert restored_state == state
  end
end
