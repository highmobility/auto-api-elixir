defmodule AutoApi.DiagnosticsCommandTest do
  use ExUnit.Case
  alias AutoApi.{DiagnosticsCommand, DiagnosticsState, PropertyComponent}

  describe "execute/2" do
    # TODO
    @tag :skip
    test "get_diagnostics_state" do
      assert DiagnosticsCommand.execute(%DiagnosticsState{}, <<0x00>>) ==
               {:state, %AutoApi.DiagnosticsState{}}
    end

    # TODO
    @tag :skip
    test "diagnostics_state" do
      mileage_prop = %PropertyComponent{data: 100}

      binary_state = DiagnosticsState.to_bin(%DiagnosticsState{mileage: mileage_prop})

      assert DiagnosticsCommand.execute(%DiagnosticsState{}, <<0x01, binary_state::binary>>) ==
               {:state_changed, %AutoApi.DiagnosticsState{mileage: mileage_prop}}
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
