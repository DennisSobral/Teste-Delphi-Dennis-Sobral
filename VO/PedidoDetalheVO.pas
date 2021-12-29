unit PedidoDetalheVO;

interface

uses produtosVO;

Type TPedidoDetalheVO = class
  private
    Fvalor_unitario: double;
    Fid_produto: integer;
    Fvalor_total: double;
    Fnumero_pedido: integer;
    Fid: integer;
    Fquantidade: double;
    FprodutoVO: TProdutosVO;
    procedure Setid(const Value: integer);
    procedure Setid_produto(const Value: integer);
    procedure Setnumero_pedido(const Value: integer);
    procedure Setquantidade(const Value: double);
    procedure Setvalor_total(const Value: double);
    procedure Setvalor_unitario(const Value: double);
    procedure SetprodutoVO(const Value: TProdutosVO);
  published

   property id: integer read Fid write Setid;
   property numero_pedido: integer read Fnumero_pedido write Setnumero_pedido;
   property id_produto: integer read Fid_produto write Setid_produto;
   property quantidade: double read Fquantidade write Setquantidade;
   property valor_unitario: double read Fvalor_unitario write Setvalor_unitario;
   property valor_total: double read Fvalor_total write Setvalor_total;

   property produtoVO: TProdutosVO read FprodutoVO write SetprodutoVO;

end;

implementation

{ TPedidoDetalheVO }

procedure TPedidoDetalheVO.Setid(const Value: integer);
begin
  Fid := Value;
end;

procedure TPedidoDetalheVO.Setid_produto(const Value: integer);
begin
  Fid_produto := Value;
end;

procedure TPedidoDetalheVO.Setnumero_pedido(const Value: integer);
begin
  Fnumero_pedido := Value;
end;

procedure TPedidoDetalheVO.SetprodutoVO(const Value: TProdutosVO);
begin
  FprodutoVO := Value;
end;

procedure TPedidoDetalheVO.Setquantidade(const Value: double);
begin
  Fquantidade := Value;
end;

procedure TPedidoDetalheVO.Setvalor_total(const Value: double);
begin
  Fvalor_total := Value;
end;

procedure TPedidoDetalheVO.Setvalor_unitario(const Value: double);
begin
  Fvalor_unitario := Value;
end;

end.
