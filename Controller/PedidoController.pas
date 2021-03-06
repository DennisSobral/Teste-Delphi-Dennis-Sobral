unit PedidoController;

interface

uses PedidoCabecalhoVO, PedidoDetalheVO, generics.collections, System.SysUtils,
     FireDAC.Comp.Client, FireDAC.DApt, vcl.dialogs, produtosVO, vcl.controls;

Type TPedidoController = class

   class Procedure GravarPedido(cabecalho: TPedidoCabecalhoVO; detalhe: TObjectList<TPedidoDetalheVO>);
   class Function RetornarUltimoID: integer;
   class Procedure CancelarPedido(id: integer);
   class Procedure CancelarItem(id: integer);
   class Function RetornarPedidoCabecalhoPorID(id: integer): TPedidoCabecalhoVO;
   class Function RetornarPedidoDetalhePorID(id: integer): TObjectList<TPedidoDetalheVO>;

end;

implementation

uses untPrincipal;

{ TPedidoController }

class procedure TPedidoController.CancelarItem(id: integer);
Var query: TFDQuery;
    transacao: TFDTransaction;
begin

   Try

      Try

        query := TFDQuery.Create(Nil);
        query.Connection := frmPrincipal.Conexao;

        transacao := TFDTransaction.Create(frmPrincipal.Conexao);
        transacao.Connection := frmPrincipal.Conexao;
        transacao.StartTransaction;

        query.SQL.Add('DELETE FROM pedido_detalhe WHERE id = '+id.ToString);
        query.ExecSQL;

        transacao.Commit;

      Except

        on e:exception do Begin
           MessageDlg('Falha ao cancelar o item.'+#13+'Erro: '+e.Message,mtError,[mbOK],0);
           transacao.Rollback;
        End;

      End;

   Finally

      FreeAndNil(query);

   End;

end;
class procedure TPedidoController.CancelarPedido(id: integer);
Var query: TFDQuery;
    transacao: TFDTransaction;
begin

   Try

      query := TFDQuery.Create(Nil);
      query.Connection := frmPrincipal.Conexao;

      query.SQL.Add('SELECT * FROM pedido_cabecalho WHERE numero = '+id.ToString);
      query.Open;

      if Not(query.IsEmpty) then Begin

         Try

            if MessageDlg('Confirma o cancelamento do pedido?', mtConfirmation,[mbYes, mbNo], 0) = mrNo then
               Exit;

            transacao := TFDTransaction.Create(frmPrincipal.Conexao);
            transacao.Connection := frmPrincipal.Conexao;
            transacao.StartTransaction;

            query.Close;
            query.SQL.Clear;
            query.SQL.Add('DELETE FROM pedido_detalhe WHERE numero_pedido = '+id.ToString);
            query.ExecSQL;

            query.Close;
            query.SQL.Clear;
            query.SQL.Add('DELETE FROM pedido_cabecalho WHERE numero = '+id.ToString);
            query.ExecSQL;

            transacao.Commit;

            MessageDlg('Pedido n? '+id.ToString+' cancelado com sucesso.',mtInformation,[mbOK],0);

         Except

            on e:exception do Begin
               MessageDlg('Falha ao cancelar o pedido.'+#13+'Erro: '+e.Message,mtError,[mbOK],0);
               transacao.Rollback;
            End;

         End;


      End else
         MessageDlg('Pedido n? '+id.ToString+' n?o foi localizado na base de dados.',mtWarning ,[mbOK],0);


   Finally

      FreeAndNil(query);

   End;

end;

class procedure TPedidoController.GravarPedido(cabecalho: TPedidoCabecalhoVO;
  detalhe: TObjectList<TPedidoDetalheVO>);
Var query: TFDQuery;
    transacao: TFDTransaction;
  I: Integer;
begin

   Try

      Try

         transacao := TFDTransaction.Create(frmPrincipal.Conexao);
         transacao.Connection := frmPrincipal.Conexao;
         transacao.StartTransaction;

         query := TFDQuery.Create(Nil);
         query.Connection := frmPrincipal.Conexao;

         if cabecalho.numero > 0 then Begin

            query.SQL.Add(' UPDATE pedido_cabecalho SET valor_total = :valor_total, id_cliente = :id_cliente WHERE numero = '+cabecalho.numero.ToString);

         End else Begin

            query.SQL.Add(' INSERT INTO pedido_cabecalho ');
            query.SQL.Add(' (  ');
            query.SQL.Add(' data_emissao, valor_total, id_cliente ');
            query.SQL.Add(' )  ');
            query.SQL.Add(' VALUES ');
            query.SQL.Add(' (  ');
            query.SQL.Add(' :data_emissao, :valor_total, :id_cliente ');
            query.SQL.Add(' ) ' );

            query.Params.ParamByName('data_emissao').AsDateTime := Now;

         End;

         query.Params.ParamByName('valor_total').AsFloat     := cabecalho.valor_total;
         query.Params.ParamByName('id_cliente').AsInteger    := cabecalho.id_cliente;

         query.ExecSQL;
         transacao.Commit;

         if Not(cabecalho.numero > 0) then
            cabecalho.numero := RetornarUltimoID;


         for I := 0 to detalhe.Count - 1 do Begin

            transacao.StartTransaction;

            query.Close;
            query.SQL.Clear;
            query.SQL.Add(' INSERT INTO pedido_detalhe ' );
            query.SQL.Add(' (   ' );
            query.SQL.Add(' numero_pedido, id_produto, quantidade, valor_unitario, valor_total ' );
            query.SQL.Add(' )  ' );
            query.SQL.Add(' VALUES ' );
            query.SQL.Add(' (   ' );
            query.SQL.Add(' :numero_pedido, :id_produto, :quantidade, :valor_unitario, :valor_total ' );
            query.SQL.Add(' ) ' );

            query.Params.ParamByName('numero_pedido').AsInteger  := cabecalho.numero;
            query.Params.ParamByName('id_produto').AsInteger     := detalhe.Items[i].id_produto;
            query.Params.ParamByName('quantidade').AsFloat       := detalhe.Items[i].quantidade;
            query.Params.ParamByName('valor_unitario').AsFloat   := detalhe.Items[i].valor_unitario;
            query.Params.ParamByName('valor_total').AsFloat      := detalhe.Items[i].valor_total;

            query.ExecSQL;
            transacao.Commit;

         End;

         MessageDlg('Pedido n? '+cabecalho.numero.ToString+' gravado com sucesso.',mtInformation,[mbOK],0);
         frmPrincipal.LimparTela;


      Except

         on e:exception do Begin
            MessageDlg('Falha ao gravar o pedido.'+#13+'Erro: '+e.Message,mtError,[mbOK],0);
            transacao.Rollback;
         End;

      End;

   Finally

      FreeAndNil(query);

   End;

end;

class function TPedidoController.RetornarPedidoCabecalhoPorID(id: integer): TPedidoCabecalhoVO;
Var query: TFDQuery;
    cabecalho: TPedidoCabecalhoVO;
begin

   Try

      cabecalho := TPedidoCabecalhoVO.Create;

      query := TFDQuery.Create(Nil);
      query.Connection := frmPrincipal.Conexao;

      query.SQL.Add(' SELECT * FROM pedido_cabecalho WHERE numero = '+id.tostring);
      query.open;

      if Not(query.IsEmpty) then Begin

         cabecalho.numero      := query.FieldByName('numero').AsInteger;
         cabecalho.valor_total := query.FieldByName('valor_total').AsFloat;
         cabecalho.id_cliente  := query.FieldByName('id_cliente').AsInteger;

      End;

      Result := cabecalho;

   Finally

      FreeAndNil(query);

   End;

end;

class function TPedidoController.RetornarPedidoDetalhePorID(id: integer): TObjectList<TPedidoDetalheVO>;
Var query: TFDQuery;
    listaDetalhe: TObjectList<TPedidoDetalheVO>;
    detalhe: TPedidoDetalheVO;
begin

   Try

      listaDetalhe := TObjectList<TPedidoDetalheVO>.Create;

      query := TFDQuery.Create(Nil);
      query.Connection := frmPrincipal.Conexao;

      query.SQL.Add('  SELECT d.*, p.descricao ');
      query.SQL.Add('    FROM pedido_detalhe d INNER JOIN produtos p ON d.id_produto = p.codigo ');
      query.SQL.Add('   WHERE d.numero_pedido = '+id.ToString);
      query.Open;

      while Not(query.Eof) do Begin

         detalhe := TPedidoDetalheVO.Create;

         detalhe.produtoVO := TProdutosVO.Create;

         detalhe.id             := query.FieldByName('id').AsInteger;
         detalhe.numero_pedido  := query.FieldByName('numero_pedido').AsInteger;
         detalhe.id_produto     := query.FieldByName('id_produto').AsInteger;
         detalhe.quantidade     := query.FieldByName('quantidade').AsFloat;
         detalhe.valor_unitario := query.FieldByName('valor_unitario').AsFloat;
         detalhe.valor_total    := query.FieldByName('valor_total').AsFloat;
         detalhe.produtoVO.descricao := Trim(query.FieldByName('descricao').AsString);

         listaDetalhe.Add(detalhe);

         query.Next;

      End;

      Result := listaDetalhe;

   Finally

      FreeAndNil(query);

   End;

end;

class function TPedidoController.RetornarUltimoID: integer;
Var query: TFDQuery;
begin

   Try

      query := TFDQuery.Create(Nil);
      query.Connection := frmPrincipal.Conexao;

      query.SQL.Add('SELECT COALESCE(MAX(numero),0) AS id FROM pedido_cabecalho');
      query.Open;

      Result := query.FieldByName('id').AsInteger;

   Except

   End;

end;

end.
