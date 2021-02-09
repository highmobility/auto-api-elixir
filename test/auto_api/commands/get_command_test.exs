defmodule AutoApi.GetCommandTest do
  use ExUnit.Case, async: true
  use PropCheck
  doctest AutoApi.GetCommand

  alias AutoApi.GetCommand, as: SUT

  property "to_bin/1 and from_bin/1 are inverse" do
    forall {capability, properties} <- capability_with_properties() do
      command = %SUT{capability: capability, properties: properties}

      assert cmd_bin = SUT.to_bin(command)
      assert command == SUT.from_bin(cmd_bin)
    end
  end

  defp capability_with_properties() do
    let [
      capability <- capability(),
      properties <- properties(^capability)
    ] do
      {capability, properties}
    end
  end

  defp capability() do
    oneof(AutoApi.Capability.all())
  end

  defp properties(capability) do
    properties =
      capability.properties()
      |> Enum.map(&elem(&1, 1))

    shrink_list(properties)
  end
end
