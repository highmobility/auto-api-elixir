defmodule AutoApi.SetCommandTest do
  use ExUnit.Case, async: true
  use PropCheck
  import AutoApi.PropCheckFixtures

  doctest AutoApi.SetCommand

  alias AutoApi.SetCommand, as: SUT

  property "new/1 works" do
    forall {capability, state} <- capability_with_state() do
      command = SUT.new(state)

      assert %SUT{capability: capability, state: state} == command
    end
  end

  property "new/2 works" do
    forall {capability, state} <- capability_with_state() do
      command = SUT.new(capability, state)

      assert %SUT{capability: capability, state: state} == command
    end
  end

  property "to_bin/1 and from_bin/1 are inverse" do
    forall {capability, state} <- capability_with_state() do
      command = SUT.new(capability, state)

      assert cmd_bin = SUT.to_bin(command)
      assert command == SUT.from_bin(cmd_bin)
    end
  end
end
