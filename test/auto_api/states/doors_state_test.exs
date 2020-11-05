defmodule AutoApiL11.DoorsStateTest do
  use ExUnit.Case
  doctest AutoApiL11.DoorsState
  alias AutoApiL11.DoorsState

  test "to_bin & from_bin" do
    state =
      %DoorsState{}
      |> DoorsState.append_property(:positions, %{
        location: :front_left,
        position: :closed
      })
      |> DoorsState.append_property(:positions, %{
        location: :front_right,
        position: :open
      })
      |> DoorsState.append_property(:inside_locks, %{
        location: :front_right,
        lock_state: :unlocked
      })
      |> DoorsState.append_property(:locks, %{
        location: :front_right,
        lock_state: :unlocked
      })

    new_state =
      state
      |> DoorsState.to_bin()
      |> DoorsState.from_bin()

    assert state == new_state
  end
end
