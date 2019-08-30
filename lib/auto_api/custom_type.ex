defmodule AutoApi.CustomType do
  @moduledoc """
    Handles custom types
  """
  require AutoApi.CustomType.Implementation

  @before_compile AutoApi.CustomType.Implementation
end
