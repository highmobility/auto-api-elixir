defmodule AutoApi.SetCommandTest do
  use ExUnit.Case, async: true
  use PropCheck
  import AutoApi.PropCheckFixtures

  doctest AutoApi.SetCommand

  alias AutoApi.SetCommand, as: SUT

  property "to_bin/1 and from_bin/1 are inverse" do
    forall {capability, state} <- capability_with_state() do
      command = %SUT{capability: capability, state: state}

      assert cmd_bin = SUT.to_bin(command)
      assert command == SUT.from_bin(cmd_bin)
    end
  end
end
