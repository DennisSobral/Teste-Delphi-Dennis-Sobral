unit PedidoCabecalhoVO;

interface

Type TPedidoCabecalhoVO = class
  private
    Fvalor_total: double;
    Fdata_emissao: tdatetime;
    Fid_cliente: integer;
    Fnumero: integer;
    procedure Setdata_emissao(const Value: tdatetime);
    procedure Setid_cliente(const Value: integer);
    procedure Setnumero(const Value: integer);
    procedure Setvalor_total(const Value: double);
  published

  property numero: integer read Fnumero write Setnumero;
  property data_emissao: tdatetime read Fdata_emissao write Setdata_emissao;
  property valor_total: double read Fvalor_total write Setvalor_total;
  property id_cliente: integer read Fid_cliente write Setid_cliente;

end;

implementation

{ TPedidoCabecalhoVO }

procedure TPedidoCabecalhoVO.Setdata_emissao(const Value: tdatetime);
begin
  Fdata_emissao := Value;
end;

procedure TPedidoCabecalhoVO.Setid_cliente(const Value: integer);
begin
  Fid_cliente := Value;
end;

procedure TPedidoCabecalhoVO.Setnumero(const Value: integer);
begin
  Fnumero := Value;
end;

procedure TPedidoCabecalhoVO.Setvalor_total(const Value: double);
begin
  Fvalor_total := Value;
end;

end.
