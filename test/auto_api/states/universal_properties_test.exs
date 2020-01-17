defmodule AutoApi.UniversalPropertiesTest do
  use ExUnit.Case
  alias AutoApi.DoorsState

  @tag :skip
  test "converts the state properties and the universal properties" do
    bin_state = <<0x04, 2::integer-16, 0x00, 0x01, 0xA2, 0, 8, 18, 6, 8, 16, 8, 2, 0, 120>>

    state = DoorsState.from_bin(bin_state)

    datetime = %DateTime{
      year: 2018,
      month: 06,
      day: 08,
      hour: 16,
      minute: 8,
      second: 2,
      utc_offset: 120,
      time_zone: "",
      zone_abbr: "",
      std_offset: 0
    }

    locks = [
      %{door_location: :front_left, position: :open}
    ]

    assert state == %DoorsState{positions: locks, timestamp: datetime}
  end
end
