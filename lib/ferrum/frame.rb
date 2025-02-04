# frozen_string_literal: true

require "ferrum/frame/dom"
require "ferrum/frame/runtime"

module Ferrum
  class Frame
    include DOM, Runtime

    attr_reader :id, :page, :parent_id, :state
    attr_writer :execution_id
    attr_accessor :name

    def initialize(id, page, parent_id = nil)
      @id, @page, @parent_id = id, page, parent_id
    end

    # Can be one of:
    # * started_loading
    # * navigated
    # * scheduled_navigation
    # * cleared_scheduled_navigation
    # * stopped_loading
    def state=(value)
      @state = value
    end

    def url
      evaluate("document.location.href")
    end

    def title
      evaluate("document.title")
    end

    def main?
      @parent_id.nil?
    end

    def execution_id
      raise NoExecutionContextError unless @execution_id
      @execution_id
    rescue NoExecutionContextError
      @page.event.reset
      @page.event.wait(@page.timeout) ? retry : raise
    end

    def inspect
      %(#<#{self.class} @id=#{@id.inspect} @parent_id=#{@parent_id.inspect} @name=#{@name.inspect} @state=#{@state.inspect} @execution_id=#{@execution_id.inspect}>)
    end
  end
end
