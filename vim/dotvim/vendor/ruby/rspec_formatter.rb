require 'rspec/core/formatters/base_text_formatter'

class VimFormatter < RSpec::Core::Formatters::BaseTextFormatter
  def example_failed(example)
    exception = example.execution_result[:exception]
    spec_path = $1 if exception.backtrace.find do |frame|
      frame =~ %r{\b(spec/.*_spec\.rb:\d+)(?::|\z)}
    end
    message = format_message exception.message
    path    = format_caller spec_path
    output.puts message.strip if path
    output.puts "#{spec_path}: #{example.example_group.description.strip} #{example.description.strip}" if path
    output.puts remove_spec_from_backtrace(format_backtrace(exception.backtrace, example), spec_path)
  end

  def example_pending *args;  end
  def dump_failures *args; end
  def dump_pending *args; end
  def message msg; end
  def dump_summary *args; end
  def seed *args; end

  private

  def format_message msg
    msg.gsub('\\n', "\n").gsub(/[\n]+/, ' ').gsub(/[ ]+/, ' ')
  end

  def remove_spec_from_backtrace(backtrace, spec_path)
    custom_format_backtrace(backtrace).reject { |line|
      line.match(/#{spec_path}/)
    }
  end

  def custom_format_backtrace(backtrace)
    backtrace.map do |line|
      line.gsub('./', '')
    end
  end

end
