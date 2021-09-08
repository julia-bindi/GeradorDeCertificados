#!/bin/bash

clear
OLDIFS=IFS
IFS="
"

nomes+=$(cat notas.csv | awk -F',' '{if($2>=60){print $1}}')

nome=($nomes)
IFS=""
echo "1)Certificado de curso"
echo "2)Certificado de palestra"
read tipo
evento=("do curso" "da palestra")
echo "Qual o nome do evento?"
read curso
echo "Qual a duração (em horas)?"
read duracao

for aluno in ${nome[@]}; do
    texto="Certificamos que

"$aluno"

participou "${evento[$((tipo-1))]}" "$curso", no primeiro dia do IT Camp, evento promovido pela Commit Jr - Empresa Júnior de Engenharia de Computação, em parceria com o COMPET - Grupo PET de Engenharia de Computação, ambos projetos de extensão do CEFET-MG, no dia 06 de janeiro de 2021, com duração de "$duracao" hora(s)"
    posicionamento="\n\n\n\n\n\n\n\n\n\n\n\n\n"

    comando='BEGIN{linhas=0
    tamanho=0}
    {tamanho=length($1)
    linhas += int(tamanho/77)+1}
    END{print (linhas+12)*77.5}'

    tamanho=$(echo $texto | awk -F'\n' $comando)

    mkdir $curso 2> /dev/null

    rm $curso/$aluno.jpg 2> /dev/null

    convert -background '#00000000' -fill black -gravity center -font CutiveMono-Regular.ttf -size 3000x$tamanho \
            caption:$texto$posicionamento \
            $( ls ./certificado.jpg) +swap -gravity south -composite $curso/$aluno.jpg;
done

IFS=OLDIFS