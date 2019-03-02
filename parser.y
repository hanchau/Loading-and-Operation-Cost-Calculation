%{
#include <iostream>
#include<string>
#include <cstring>
#include <cstdlib>
using namespace std;
extern int yylex();
extern int yylineno;
void yyerror (const char* s) {
  cout<<s<<"in line:"<<yylineno<<endl;
}

const int MAX = 100;


class Node {
    string identifier, type;
    bool loaded;
    Node* next;

public:
    Node(){
        next = NULL;
    }

    Node(string key, string type){
        this->identifier = key;
        this->type = type;
        next = NULL;
    }
    friend class SymbolTable;
};


class SymbolTable {
    Node* head[MAX];

public:
    SymbolTable()
    {
        for (int i = 0; i < MAX; i++)
            head[i] = NULL;
    }
    int hashfun(string id); // hash function
    void insert(string id, string Type);
    bool find(string id);
    string returnType(string id);
    bool loadVinReg(string id);
    bool checkLoaded(string id);

};


bool SymbolTable::find(string id){
    int index = hashfun(id);
    Node* rowInTable = head[index];
    if (rowInTable == NULL)
        return false;
    while (rowInTable != NULL) {
        if (rowInTable->identifier == id) {
            return true;
        }
        rowInTable = rowInTable->next;
    }
    return false; // not found
}

string SymbolTable::returnType(string id){
    int index = hashfun(id);
    Node* rowInTable = head[index];
    if (rowInTable == NULL)
        return "-1";
    while (rowInTable != NULL) {
        if (rowInTable->identifier == id) {
            return rowInTable->type;
        }
        rowInTable = rowInTable->next;
    }
    return "-1"; // not found
}

bool SymbolTable::checkLoaded(string id){
    int index = hashfun(id);
    Node* rowInTable = head[index];
    if (rowInTable == NULL)
        return false;
    while (rowInTable != NULL) {
        if (rowInTable->identifier == id && rowInTable->loaded == true) {
            return true;
        }
        rowInTable = rowInTable->next;
    }
    return false; // not found
}

bool SymbolTable::loadVinReg(string id){
    int index = hashfun(id);
    Node* rowInTable = head[index];
    if (rowInTable == NULL)
        return false;
    while (rowInTable != NULL) {
        if (rowInTable->identifier == id) {
            rowInTable->loaded = 1;
            return true;
        }
        rowInTable = rowInTable->next;
    }
    return false; // not found
}

void SymbolTable::insert(string id, string Type){
    int index = hashfun(id);
    Node* p = new Node(id, Type);
    if (head[index] == NULL) {
        head[index] = p;
    }
    else {
        Node* rowInTable = head[index];
        while (rowInTable->next != NULL)
            rowInTable = rowInTable->next;
        rowInTable->next = p;
    }
}

int SymbolTable::hashfun(string id){
    int asciiSum = 0;
    for (int i = 0; i < id.length(); i++) {
        asciiSum = asciiSum + id[i];
    }
    return (asciiSum % 100);
}

SymbolTable Table ;

//store = s -> 0
//loadV = v -> 1
//loadC = i -> 2
// + =    a -> 3
// * =    m -> 4
int cons[5] = {0, 0, 0, 0, 0}; //count of [s v i a m] eg:= [0 0 0 0 0] all are zero


%}


%union {
  struct{
  char val[25];
  int type; // 0 - int , 1 - float
  }value;
}


%token <value> INT FLOAT O_BRAC C_BRAC ADD_OP MUL_OP ASSIGN_OP IDENTIFIER INT_C FLOAT_C SEMICOLON

%type <value> P L D V S A E T



%%



P 	: L SEMICOLON S { cout<<"sucessfully parsed"; }

    ;

L 	: D L {}

    |  {}

    ;


D 	: T V  { $2.type = $1.type;}

    ;


V  	: IDENTIFIER V
      {
          if($$.type == 0)
          {
              Table.insert($1.val, "int");
          }
          else
          {
              Table.insert($1.val, "float");
          }
      }

    | IDENTIFIER
      {
          if($$.type == 0)
          {
              Table.insert($1.val, "int");
          }
          else
          {
              Table.insert($1.val, "float");
          }
      }

    ;

S   : A S
      {

      }

  	| A
      {

      }
  	;


A   : IDENTIFIER ASSIGN_OP E
      {
        if (Table.returnType($1.val) == "int" && $3.type == 0) {
          cons[0]++;
          $$.type = 0;
        }
        else if (Table.returnType($1.val) == "float") {
          cons[0] = cons[0] + 4;
          $$.type = 1;
        }
        else{
          $$.type = -1;
        }
      }
	  ;


E   : E ADD_OP E
      {
        if ($1.type == 0 && $3.type == 0) {
          cons[3]++;
          $$.type = 0;
        }
        else {
          cons[3] = cons[3] + 4;
          $$.type = 1;
        }

      }

    | E MUL_OP E
      {
        if ($1.type == 0 && $3.type == 0) {
          cons[4]++;
          $$.type = 0;
        }
        else {
          cons[4] = cons[4] + 4;
          $$.type = 1;
        }
      }

    | O_BRAC E C_BRAC
      {
        $$.type = $2.type;
      }

    | IDENTIFIER
      {
        if (Table.returnType($1.val) == "int")
        {
          $$.type = 0;
          if (!Table.checkLoaded($1.val)) {
            Table.loadVinReg($1.val);
            cons[1]++;
          }
        }
        else if (Table.returnType($1.val) == "float")
        {
          $$.type = 1;
          if (!Table.checkLoaded($1.val)) {
            Table.loadVinReg($1.val);
            cons[1] = cons[1] +  4;
          }
        }
      }

    | FLOAT_C
      {
        $$.type = 1; // float
        cons[2] = cons[2]+4; // loading constant
  	  }

    | INT_C
      {
        $$.type = 0; // int
        cons[2] = cons[2]+1;
      }
  	;



T 	: INT
      {
        $$.type = 0; //int

      }

  	| FLOAT
      {
        $$.type = 1; //float
  	  }

  	;


%%




int main (){

  yyparse();

  return 0;
}
