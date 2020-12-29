defmodule ESBot.Commands do
  @commands %{"!e" => ESBot.Commands.Emote}

  def commands(), do: @commands

  def run(command, msg, args),
    do: apply(Map.get(@commands, command, ESBot.Commands.Default), :run, [msg, [command | args]])
end
