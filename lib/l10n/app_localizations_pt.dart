// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Aplicativo de Despesas';

  @override
  String get filterByDate => 'Filtrar por data';

  @override
  String get filterByCategory => 'Filtrar por categoria';

  @override
  String get allTime => 'Todo o Período';

  @override
  String get lastWeek => 'Última Semana';

  @override
  String get lastMonth => 'Último Mês';

  @override
  String get thisWeek => 'Esta Semana';

  @override
  String get thisMonth => 'Este Mês';

  @override
  String get selectRange => 'Selecionar Período';

  @override
  String get customRange => 'Período Personalizado';

  @override
  String get noData => 'Nenhum dado para exibir';

  @override
  String get noExpenses => 'Nenhuma despesa encontrada';

  @override
  String get noExpensesPeriod =>
      'Nenhuma despesa encontrada para o período selecionado';

  @override
  String get addFirstExpense => 'Adicione Sua Primeira Despesa';

  @override
  String totalExpenses(Object count) {
    return 'Despesas Totais: $count';
  }

  @override
  String totalAmount(Object total) {
    return 'Valor Total: \$$total';
  }

  @override
  String get expensesByCategory => 'Despesas por categoria';

  @override
  String get loginTitle => 'Login';

  @override
  String get usernameLabel => 'Nome de usuário';

  @override
  String get passwordLabel => 'Senha';

  @override
  String get loginButton => 'Login';

  @override
  String get authInvalidCredentials => 'Nome ou senha inválidos';

  @override
  String get welcomeMessage => 'Bem-vindo ao seu aplicativo de orçamento';

  @override
  String get manageExpenses => 'Gere as despesas de forma eficiente';

  @override
  String get addNewExpense => 'Adicionar Nova Despesa';

  @override
  String get addExpenseType => 'Adicionar Tipo de Despesa';

  @override
  String get viewAllExpenses => 'Ver Todas as Despesas';

  @override
  String errorLoadingExpenses(Object error) {
    return 'Erro ao carregar despesas: $error';
  }

  @override
  String get allExpensesTitle => 'Todas as Despesas';

  @override
  String get sortByDate => 'Ordenar por Data';

  @override
  String get sortByAmount => 'Ordenar por Valor';

  @override
  String get sortByTitle => 'Ordenar por Título';

  @override
  String get pageNotFoundTitle => 'Página Não Encontrada';

  @override
  String pageNotFoundMessage(Object path) {
    return 'Página não encontrada: $path';
  }

  @override
  String get goHome => 'Ir para Início';

  @override
  String errorLoadingExpenseTypes(Object error) {
    return 'Erro ao carregar tipos de despesa: $error';
  }

  @override
  String get pleaseSelectExpenseType =>
      'Por favor selecione um tipo de despesa';

  @override
  String get expenseCreated => 'Despesa criada com sucesso!';

  @override
  String errorGeneric(Object error) {
    return 'Erro: $error';
  }

  @override
  String get addExpenseTitle => 'Adicionar Despesa';

  @override
  String get labelTitle => 'Título';

  @override
  String get labelDescription => 'Descrição';

  @override
  String get labelAmount => 'Valor';

  @override
  String get labelDate => 'Data';

  @override
  String get labelExpenseType => 'Tipo de Despesa';

  @override
  String get pleaseEnterTitle => 'Por favor insira um título';

  @override
  String get pleaseEnterAmount => 'Por favor insira um valor';

  @override
  String get pleaseEnterValidAmount =>
      'Por favor insira um valor válido maior que 0';

  @override
  String get noExpenseTypesAvailable => 'Nenhum tipo de despesa disponível.';

  @override
  String get createExpenseType => 'Criar Tipo de Despesa';

  @override
  String get saveExpense => 'Salvar Despesa';

  @override
  String get expenseTypeCreated => 'Tipo de despesa criado com sucesso!';

  @override
  String get expenseTypeUpdated => 'Tipo de despesa atualizado com sucesso!';

  @override
  String get addExpenseTypeTitle => 'Adicionar Tipo de Despesa';

  @override
  String get updateExpenseTypeTitle => 'Atualizar Tipo de Despesa';

  @override
  String get updateExpenseType => 'Atualizar Tipo de Despesa';

  @override
  String get labelName => 'Nome';

  @override
  String get labelSelectColor => 'Selecionar Cor';

  @override
  String get pleaseEnterName => 'Por favor insira um nome';

  @override
  String get pleaseEnterDescription => 'Por favor insira uma descrição';

  @override
  String get saveExpenseType => 'Salvar Tipo de Despesa';

  @override
  String get unknown => 'Desconhecido';

  @override
  String get expenseTypesTitle => 'Tipos de Despesa';

  @override
  String get viewExpenseTypes => 'Ver Tipos de Despesa';

  @override
  String get noExpenseTypesYet => 'Ainda não há tipos de despesa';

  @override
  String get addFirstType => 'Adicione o Primeiro Tipo';

  @override
  String get deleteExpenseType => 'Excluir Tipo de Despesa';

  @override
  String deleteExpenseTypeConfirm(String name) {
    return 'Tem certeza de que deseja excluir \"$name\"? Esta ação não pode ser desfeita.';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String expenseTypeDeleted(String name) {
    return '$name excluído com sucesso';
  }

  @override
  String errorDeletingExpenseType(String error) {
    return 'Erro ao deletar tipo de despesa: $error';
  }

  @override
  String cannotDeleteExpenseTypeInUse(int count) {
    return 'Não é possível deletar este tipo de despesa porque está sendo usado por $count despesa(s)';
  }
}
