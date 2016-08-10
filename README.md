# Spiders

A simple web-crawler app written in Exlixir. Meant to learn and test the
usefulness of Elixir's process model, and its functional paradigms.

This is a first-attempt at Elixir, and functional programming in
general. Feedback is welcome regarding coding-style and "correct use" of
functional languages in general.

The application will operate both as a CLI utility to collect JSON
results of web crawls, as well as a daemonized service useful for
fufilling requests to a web front-end.

## Roadmap

  1. Create a simple tool that will analyze a host for missing (404),
     moved (301), or faulty (500) links, returning them in a format
     suitable for display in a javascript web application.

  2. Generalize the application to allow extensible analysis pipelines
     to be included in ever more customizable web spidering sessions.

  3. Research and benchmark Elixir's distribution abilities to run scans
     across multiple, potentially dynamically-scaled hosts for very fast
     analysis of text-processing pipelines.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `spiders` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:spiders, "~> 0.1.0"}]
    end
    ```

  2. Ensure `spiders` is started before your application:

    ```elixir
    def application do
      [applications: [:spiders]]
    end
    ```

