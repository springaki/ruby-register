# レジスターを表すクラス
class Register
  # 商品の種類と価格
  PRICES = {
      apple: 300,
      banana: 200,
      lemon: 100
  }.freeze

  # 累計売上額
  #
  # ==== 使用例
  #
  # 累計売上額は1100円
  #
  #    register.sales_total
  #    #=> 1100
  #
  # ==== 戻り値
  #
  # * +int+ - 累計売上額
  attr_reader :sales_total

  # Registerオブジェクトの作成
  #
  # ==== 使用例
  #
  # 500円玉5枚と100円玉を10枚入れたレジスターを作成する
  #
  #    register = Register.new(500 => 5, 100 => 10)
  #
  # ==== 引数
  #
  # * +hash+ - レジスターに格納する紙幣・硬貨の種類と枚数
  def initialize(cash = {})
    @drawer = { 1000 => 0, 500 => 0, 100 => 0 }
    @sales_total = 0
    @drawer.merge!(cash)
  end

  # ドロアに格納されている現金
  #
  # ==== 使用例
  #
  # ドロアには1000円札が1枚、500円玉が6枚、100円玉が6枚格納されている
  #
  #    register.drawer
  #    #=> { 1000 => 1, 500 => 6, 100 => 6 }
  #
  # ==== 戻り値
  #
  # * +hash+ - ドロアに格納されている紙幣・硬貨の種類と枚数
  def drawer
    @drawer.dup
  end

  # 商品を購入する
  #
  # ==== 使用例
  #
  # りんご3個とレモン2個を売り、1000円札1枚と500円玉1枚を受け取る<br>
  # お釣りは100円玉が4枚
  #
  #    registey.sale(apple: 3, lemon: 2, payments: { 1000 => 1, 500 => 1 })
  #    #=> { 100 => 4 }
  #
  # ==== 引数
  #
  # * +apple+ +banana+ +lemon+ - 購入する商品の種類と個数
  # * +payments+ - 支払いで使う紙幣・硬貨の種類と枚数
  #
  # ==== 戻り値
  #
  # * +hash+ - お釣りとして返される紙幣・硬貨の種類と枚数
  def sale(apple: 0, banana: 0, lemon: 0, payments: {})
    total = PRICES[:apple] * apple + PRICES[:banana] * banana + PRICES[:lemon] * lemon

    payment = 0
    payments.each do |money, amount|
      payment += money * amount
    end

    @sales_total += total

    payments.each do |money, amount|
      @drawer[money] += amount
    end

    change_amount = (payment - total) / 100
    @drawer[100] -= change_amount
    if change_amount > 0
      { 100 => change_amount }
    else
      {}
    end
  end
end