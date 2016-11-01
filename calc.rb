def calculate(str)
  postfix_notation = InfixNotation.new(str).to_postfix
  solution = PostfixNotation.new(postfix_notation).solve

  solution
end

class InfixNotation

  PRECEDENCES = {
      :'+' => 1,
      :'-' => 1,
      :'*' => 2,
      :'/' => 2
  }

  def initialize(input)
    @input = input
    @stack = []
  end

  def to_postfix
    @postfix_notation = ''
    parts = @input.gsub(' ', '').split(/([\(\)\+\-\/\*])/).reject(&:empty?)

    parts.each do |part|
      case part
        when '+', '-', '*', '/'
          got_operator(part, precedence(part))
        when '(', ')'
          got_parenthesis(part)
        else
          add_to_postfix part
      end
    end

    until @stack.empty?
      add_to_postfix @stack.pop
    end

    @postfix_notation
  end

  private

  def got_operator(operator, precedence)
    until @stack.empty?
      top_operator = @stack.pop
      if top_operator == '('
        @stack.push(top_operator)
        break
      else
        precedence_on_stack = precedence(top_operator)

        if precedence_on_stack < precedence
          @stack.push(top_operator)
          break
        else
          add_to_postfix top_operator
        end
      end
    end

    @stack.push(operator)
  end

  def got_parenthesis(parenthesis)
    if parenthesis == '('
      @stack.push(parenthesis)
    else
      until @stack.empty?
        top_operator = @stack.pop
        if top_operator == '('
          break
        else
          add_to_postfix top_operator
        end
      end
    end

  end

  def add_to_postfix(something)
    @postfix_notation += something + ' '
  end

  def precedence(operator)
    PRECEDENCES[operator.to_sym] || 1
  end
end

class PostfixNotation

  OPERATORS = %w(+ - / *)

  def initialize(input)
    @input = input
  end

  def solve
    parts = @input.split(' ')
    until parts.length == 1
      operator_index = parts.index{|element| OPERATORS.include?(element)}
      break unless operator_index

      operator = parts[operator_index]
      operand1 = parts[operator_index - 2].to_i
      operand2 = parts[operator_index - 1].to_i
      case operator
        when '+'
          parts[(operator_index - 2)..operator_index] = operand1 + operand2
        when '-'
          parts[(operator_index - 2)..operator_index] = operand1 - operand2
        when '*'
          parts[(operator_index - 2)..operator_index] = operand1 * operand2
        when '/'
          parts[(operator_index - 2)..operator_index] = operand1 / operand2
        else
          puts "Unrecognized operator #{operator}"
      end
    end

    parts.first
  end
end












































































