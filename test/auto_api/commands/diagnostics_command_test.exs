defmodule AutoApiL11.DiagnosticsCommandTest do
  use ExUnit.Case
  alias AutoApiL11.{DiagnosticsCommand, DiagnosticsState, PropertyComponent}

  describe "execute/2" do
    # TODO
    @tag :skip
    test "get_diagnostics_state" do
      assert DiagnosticsCommand.execute(%DiagnosticsState{}, <<0x00>>) ==
               {:state, %AutoApiL11.DiagnosticsState{}}
    end

    # TODO
    @tag :skip
    test "diagnostics_state" do
      mileage_prop = %PropertyComponent{data: 100}

      binary_state = DiagnosticsState.to_bin(%DiagnosticsState{mileage: mileage_prop})

      assert DiagnosticsCommand.execute(%DiagnosticsState{}, <<0x01, binary_state::binary>>) ==
               {:state_changed, %AutoApiL11.DiagnosticsState{mileage: mileage_prop}}
    end
  end

  describe "state/1" do
    # TODO
    @tag :skip
    test "get state" do
      state = %DiagnosticsState{mileage: %PropertyComponent{data: 100}}

      assert DiagnosticsCommand.state(state) == <<0x01>> <> DiagnosticsState.to_bin(state)
    end
  end
end
