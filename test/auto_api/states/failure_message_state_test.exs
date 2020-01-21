defmodule AutoApi.FailureMessageStateTest do
  use ExUnit.Case
  alias AutoApi.FailureMessageState

  test "to_bin & from_bin" do
    state =
      %FailureMessageState{}
      |> FailureMessageState.put_property(:failed_message_id, 0x35)
      |> FailureMessageState.put_property(:failed_message_type, 0x00)
      |> FailureMessageState.put_property(:failure_reason, :unauthorized)
      |> FailureMessageState.put_property(
        :failure_description,
        "Access to this capability was not granted"
      )

    new_state =
      state
      |> FailureMessageState.to_bin()
      |> FailureMessageState.from_bin()

    assert new_state == state
  end
end
