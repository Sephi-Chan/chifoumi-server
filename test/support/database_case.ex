defmodule Chifoumi.DatabaseCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Commanded.Assertions.EventAssertions
    end
  end

  setup do
    {:ok, _} = Application.ensure_all_started(:chifoumi)

    on_exit(fn ->
      :ok = Application.stop(:chifoumi)
      :ok = Application.stop(:commanded)
      :ok = Application.stop(:eventstore)

      config = Application.get_env(:chifoumi, Chifoumi.EventStore) |> EventStore.Config.default_postgrex_opts()
      {:ok, conn} = Postgrex.start_link(config)

      EventStore.Storage.Initializer.reset!(conn)
    end)

    :ok
  end
end
