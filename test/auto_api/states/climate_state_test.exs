defmodule AutoApi.ClimateStateTest do
  use ExUnit.Case, async: true
  doctest AutoApi.ClimateState

  alias AutoApi.ClimateState

  describe "regressions" do
    test "hvac_weekday_starting_time is (de)serialized correctly" do
      starting_time = %{
        time: %{hour: 18, minute: 30},
        weekday: :monday
      }

      state_base = ClimateState.base()

      state =
        ClimateState.append_property(state_base, :hvac_weekday_starting_times, starting_time)

      assert state ==
               state
               |> ClimateState.to_bin()
               |> ClimateState.from_bin()
    end
  end
end
