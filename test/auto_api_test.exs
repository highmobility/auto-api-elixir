defmodule AutoApiTest do
  use ExUnit.Case
  doctest AutoApiL11

  require Assertions
  import Assertions, only: [assert_lists_equal: 2]

  test "State properties are updated for all capabilities" do
    AutoApiL11.Capability.all()
    |> Enum.map(fn cap -> {cap.state.base, cap.properties} end)
    |> Enum.all?(fn {state, properties} ->
      state_properties = Map.keys(state) -- [:__struct__, :timestamp]
      spec_properties = Enum.map(properties, &elem(&1, 1))

      assert_lists_equal(state_properties, spec_properties)
    end)
  end
end
