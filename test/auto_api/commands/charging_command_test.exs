defmodule AutoApiL11.ChargingCommandTest do
  use ExUnit.Case
  alias AutoApiL11.{ChargingCommand, ChargingState, PropertyComponent}

  describe "execute/2" do
    # TODO
    @tag :skip
    test "get_charge_state" do
      assert ChargingCommand.execute(%ChargingState{}, <<0x00>>) == {:state, %ChargingState{}}
    end

    # TODO
    @tag :skip
    test "charge_state" do
      estimated_range_prop = %PropertyComponent{data: 100}
      binary_state = ChargingState.to_bin(%ChargingState{estimated_range: estimated_range_prop})

      assert ChargingCommand.execute(%ChargingState{}, <<0x01, binary_state::binary>>) ==
               {:state_changed, %ChargingState{estimated_range: estimated_range_prop}}
    end
  end

  describe "state/1" do
    # TODO
    @tag :skip
    test "get state" do
      state = %ChargingState{estimated_range: %PropertyComponent{data: 100}}

      assert ChargingCommand.state(state) == <<0x01>> <> ChargingState.to_bin(state)
    end
  end
end
