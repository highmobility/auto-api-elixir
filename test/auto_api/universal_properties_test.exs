defmodule AutoApi.UniversalPropertiesTest do
  use ExUnit.Case, async: true
  use PropCheck

  doctest AutoApi.UniversalProperties

  alias AutoApi.{DoorsState, State, UniversalProperties}

  test "converts the state properties and the universal properties" do
    bin_state = <<4, 0, 5, 1, 0, 2, 0, 1, 162, 0, 11, 1, 0, 8, 0, 0, 1, 99, 224, 39, 154, 208>>

    timestamp = %AutoApi.Property{data: ~U[2018-06-08 16:08:02.000Z]}

    positions = [
      %AutoApi.Property{data: %{location: :front_left, position: :open}}
    ]

    assert state = DoorsState.from_bin(bin_state)
    assert state == %DoorsState{positions: positions, timestamp: timestamp}
  end

  property "States can convert all universal_properties" do
    forall data <- [
             capability: capabilities(),
             timestamp: datetime(),
             nonce: binary(9),
             signature: binary(64),
             vin: binary(17),
             brand: brand()
           ] do
      state_module = data[:capability].state()

      state =
        state_module.base()
        |> State.put(:nonce, data: data[:nonce])
        |> State.put(:vehicle_signature, data: data[:signature])
        |> State.put(:timestamp, data: data[:timestamp])
        |> State.put(:vin, data: data[:vin])
        |> State.put(:brand, data: data[:brand])

      state_bin = state_module.to_bin(state)
      assert state == state_module.from_bin(state_bin)
    end
  end

  property "brands() contains all values" do
    forall data <- [brand: brand()] do
      assert data[:brand] in UniversalProperties.brands()
    end
  end

  defp brand() do
    brands =
      UniversalProperties.raw_spec()
      |> Map.get("universal_properties")
      |> Enum.find(&(&1["name"] == "brand"))
      |> Map.get("enum_values")
      |> Enum.map(& &1["name"])
      |> Enum.map(&String.to_atom/1)

    oneof(brands)
  end

  defp capabilities() do
    oneof(AutoApi.Capability.all())
  end

  defp datetime do
    let timestamp <-
          oneof([
            nil,
            0,
            range(1, 1_000_000),
            range(1_550_226_102_909, 9_550_226_102_909),
            9_999_999_999_999
          ]) do
      case timestamp && DateTime.from_unix(timestamp, :millisecond) do
        {:ok, datetime} -> datetime
        _ -> nil
      end
    end
  end
end
