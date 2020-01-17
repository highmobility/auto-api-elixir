defmodule AutoApi.HistoricalStateTest do
  use ExUnit.Case
  doctest AutoApi.HistoricalState

  alias AutoApi.{ChargingState, HistoricalState, PropertyComponent}

  test "from_bin/1 and to_bin/1" do
    states = [
      %PropertyComponent{
        data: %ChargingState{battery_level: %PropertyComponent{data: 0.6}},
        timestamp: ~U[2019-10-16 12:34:04.000Z]
      },
      %PropertyComponent{
        data: %ChargingState{battery_level: %PropertyComponent{data: 0.75}},
        timestamp: ~U[2019-10-16 13:34:04.000Z]
      },
      %PropertyComponent{
        data: %ChargingState{battery_level: %PropertyComponent{data: 0.89}},
        timestamp: ~U[2019-10-16 14:34:04.000Z]
      }
    ]

    state = %HistoricalState{
      states: states,
      capability_id: %PropertyComponent{data: 35},
      start_date: %PropertyComponent{data: ~U[2019-10-16 12:34:04.000Z]},
      end_date: %PropertyComponent{data: ~U[2019-10-16 14:34:04.000Z]}
    }

    restored_state =
      state
      |> HistoricalState.to_bin()
      |> HistoricalState.from_bin()

    assert restored_state == state
  end
end
