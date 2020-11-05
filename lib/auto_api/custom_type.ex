defmodule AutoApiL11.CustomType do
  @moduledoc """
    Handles custom types
  """
  require AutoApiL11.CustomType.Implementation

  @before_compile AutoApiL11.CustomType.Implementation
end
