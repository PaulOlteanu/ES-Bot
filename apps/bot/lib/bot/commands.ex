defmodule Bot.Commands do
  @commands %{"!e" => Bot.Commands.Emote}

  def commands(), do: @commands

  def run(command, msg, args),
    do: apply(Map.get(@commands, command, Bot.Commands.Default), :run, [msg, [command | args]])
end
