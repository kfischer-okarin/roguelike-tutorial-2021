# Including this file will make the inspect method work more like in CRuby.
# Additionally it will shorten long array/hash representations

class Object # rubocop:disable Style/Documentation
  def inspect
    instance_variable_values = instance_variables.map { |variable_name|
      "#{variable_name}=#{instance_variable_get(variable_name).short_inspect}"
    }.join(' ')
    instance_variable_values = " #{instance_variable_values}" unless instance_variable_values.empty?

    "#<#{self.class.name}:0x#{object_id.to_s(16)}#{instance_variable_values}>"
  end

  def short_inspect
    inspect
  end
end

class Array # rubocop:disable Style/Documentation
  def short_inspect
    original_inspect = inspect
    return original_inspect if original_inspect.size <= 100

    "[#{self[0].short_inspect}, ...(#{size - 1} more)...]"
  end
end

class Hash # rubocop:disable Style/Documentation
  def short_inspect
    original_inspect = inspect
    return original_inspect if original_inspect.size <= 100

    first_key = keys.first
    "{#{first_key.short_inspect}=>#{self[first_key].short_inspect}, ...(#{size - 1} more)...}"
  end
end

# Adapted from https://github.com/DragonRuby/dragonruby-game-toolkit-contrib/blob/master/dragon/console.rb
# Uses inspect instead of to_s in console output
# rubocop:disable all
module GTK
  class Console
    def eval_the_set_command
      cmd = current_input_str.strip
      if cmd.length != 0
        @log_offset = 0
        prompt.clear

        @command_history.pop while @command_history.length >= @max_history
        @command_history.unshift cmd
        @command_history_index = -1
        @nonhistory_input = ''

        if cmd == 'quit' || cmd == ':wq' || cmd == ':q!' || cmd == ':q' || cmd == ':wqa'
          $gtk.request_quit
        elsif cmd.start_with? ':'
          send ((cmd.gsub '-', '_').gsub ':', '')
        else
          puts "-> #{cmd}"
          begin
            @last_command = cmd
            Kernel.eval("$results = (#{cmd})")
            if $results.nil?
              puts "=> nil"
            elsif $results == :console_silent_eval
              # do nothing since the console is silent
            else
              # ==================== INSERTED CHANGE START ====================
              puts "=> #{$results.inspect}"
              # ==================== INSERTED CHANGE END ====================
            end
            @last_command_errored = false
          rescue Exception => e
            try_search_docs e
            # if an exception is thrown and the bactrace includes something helpful, then show it
            if (e.backtrace || []).first && (e.backtrace.first.include? "(eval)")
              puts  "* EXCEPTION: #{e}"
            else
              puts  "* EXCEPTION: #{e}\n#{e.__backtrace_to_org__}"
            end
          end
        end
      end
    end
  end
end
# rubocop:enable all
