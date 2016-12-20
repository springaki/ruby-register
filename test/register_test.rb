require './lib/register'
require 'minitest/autorun'

class RegisterTest < Minitest::Test
  def test_register
    register = Register.new(500 => 5, 100 => 10)
    assert_equal(
        { 1000 => 0, 500 => 5, 100 => 10 },
        register.drawer
    )
    assert_equal(0, register.sales_total)

    assert_equal(
        {},
        register.sale(lemon: 1, payments: { 100 => 1 })
    )
    assert_equal(
        { 1000 => 0, 500 => 5, 100 => 11 },
        register.drawer
    )
    assert_equal(100, register.sales_total)

    assert_equal(
        { 100 => 2 },
        register.sale(banana: 4, payments: { 500 => 2 })
    )
    assert_equal(
        { 1000 => 0, 500 => 7, 100 => 9 },
        register.drawer
    )
    assert_equal(900, register.sales_total)

    assert_equal(
        { 100 => 4 },
        register.sale(apple: 3, lemon: 2, payments: { 1000 => 1, 500 => 1 })
    )
    assert_equal(
        { 1000 => 1, 500 => 8, 100 => 5 },
        register.drawer
    )
    assert_equal(2000, register.sales_total)
  end

  def test_prices
    assert_equal(
        { apple: 300, banana: 200, lemon: 100 },
        Register::PRICES
    )
    assert_raises(RuntimeError) do
      Register::PRICES[:apple] = 100
    end
    assert_equal(
        { apple: 300, banana: 200, lemon: 100 },
        Register::PRICES
    )
  end

  def test_drawer
    register = Register.new
    assert_equal(
        { 1000 => 0, 500 => 0, 100 => 0 },
        register.drawer
    )
    register.drawer[1000] = 10
    assert_equal(
        { 1000 => 0, 500 => 0, 100 => 0 },
        register.drawer
    )
  end
end