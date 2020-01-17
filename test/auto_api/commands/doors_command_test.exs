defmodule AutoApi.DoorsCommandTest do
  use ExUnit.Case
  alias AutoApi.{DoorsCommand, DoorsState, PropertyComponent}

  describe "execute/2" do
    # TODO
    @tag :skip
    test "lock_unlock_doors lock command" do
      command = DoorsCommand.to_bin(:set, lock_state: :lock)

      state =
        DoorsState.append_property(%DoorsState{}, :locks, %{
          door_location: :front_right,
          lock_state: :unlocked
        })

      assert {:state_changed, new_state} = DoorsCommand.execute(state, command)

      assert new_state.locks == [
               %PropertyComponent{data: %{door_location: :front_right, lock_state: :locked}}
             ]
    end

    # TODO
    @tag :skip
    test "lock_unlock_doors unlock command" do
      command = DoorsCommand.to_bin(:set, lock_state: :unlock)

      state =
        DoorsState.append_property(%DoorsState{}, :locks, %{
          door_location: :front_right,
          lock_state: :locked
        })

      assert {:state_changed, new_state} = DoorsCommand.execute(state, command)

      assert new_state.locks == [
               %PropertyComponent{data: %{door_location: :front_right, lock_state: :unlocked}}
             ]
    end
  end
end
