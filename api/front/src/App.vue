<script setup>
import { ref, onMounted, computed } from "vue";

const apiBaseUrl = "http://127.0.0.1:8000"; // URL do backend
const servidorOnline = ref(false);
const cabecalhos = ref([]);
const campoSelecionado = ref("");
const termoPesquisa = ref("");
const registros = ref([]);
const paginaAtual = ref(1);
const itensPorPagina = 10;

const totalPaginas = computed(() => Math.ceil(registros.value.length / itensPorPagina));
const registrosPaginados = computed(() => {
  const inicio = (paginaAtual.value - 1) * itensPorPagina;
  return registros.value.slice(inicio, inicio + itensPorPagina);
});

const verificarServidor = async () => {
  try {
    const response = await fetch(`${apiBaseUrl}/`, { mode: "cors" });
    if (!response.ok) throw new Error("Resposta inválida");
    servidorOnline.value = true;
    await carregarCabecalhos();
  } catch (error) {
    servidorOnline.value = false;
    setTimeout(verificarServidor, 5000);
  }
};

const carregarCabecalhos = async () => {
  try {
    const response = await fetch(`${apiBaseUrl}/registros/cabecalho/`);
    const data = await response.json();
    cabecalhos.value = data.colunas;
  } catch (error) {
    console.error("Erro ao carregar cabeçalhos", error);
  }
};

const buscarRegistros = async () => {
  if (!termoPesquisa.value) return;
  const url = campoSelecionado.value
    ? `${apiBaseUrl}/registros/busca/campo/?campo=${campoSelecionado.value}&termo=${termoPesquisa.value}`
    : `${apiBaseUrl}/registros/busca/?termo=${termoPesquisa.value}`;

  try {
    const response = await fetch(url);
    const data = await response.json();
    registros.value = data.registros;
    paginaAtual.value = 1;
  } catch (error) {
    console.error("Erro ao buscar registros", error);
  }
};

const mudarPagina = (novaPagina) => {
  if (novaPagina >= 1 && novaPagina <= totalPaginas.value) {
    paginaAtual.value = novaPagina;
  }
};

onMounted(() => {
  verificarServidor();
});
</script>

<template>
  <div class="min-h-screen h-screen bg-gray-600 p-6">
    <div class="overflow-auto h-full max-w-10/12 mx-auto bg-white shadow-lg rounded-lg p-6">
      <h1 class="text-2xl font-bold text-gray-800 mb-4">Busca de Registros</h1>
      <p class="flex items-center gap-2">
        <span
          class="w-3 h-3 rounded-full"
          :class="servidorOnline ? 'bg-green-500' : 'bg-red-500'"
        ></span>
        <span :class="servidorOnline ? 'text-green-600' : 'text-red-600'">
          Servidor: {{ servidorOnline ? "Online" : "Offline" }}
        </span>
      </p>

      <div class="mt-4 flex gap-2">
        <select v-model="campoSelecionado" :disabled="!servidorOnline" class="border p-2 rounded w-1/3 max-w-xs">
          <option value="">Busca Global</option>
          <option v-for="cab in cabecalhos" :key="cab" :value="cab">{{ cab }}</option>
        </select>

        <input v-model="termoPesquisa" :disabled="!servidorOnline" type="text" placeholder="Digite um termo..."
          class="border p-2 rounded flex-1" />

        <button @click="buscarRegistros" :disabled="!servidorOnline"
          class="bg-blue-500 text-white px-4 py-2 rounded disabled:bg-gray-400 min-w-18 w-1/4 max-w-xs">
          Buscar
        </button>
      </div>

      <div v-if="registros.length" class="mt-6 overflow-x-auto">
        <div class="flex justify-between items-center mb-2">
          <button @click="mudarPagina(paginaAtual - 1)" :disabled="paginaAtual === 1" class="px-3 py-1 bg-gray-300 rounded disabled:opacity-50">&laquo; Anterior</button>
          <span>Página {{ paginaAtual }} de {{ totalPaginas }}</span>
          <button @click="mudarPagina(paginaAtual + 1)" :disabled="paginaAtual === totalPaginas" class="px-3 py-1 bg-gray-300 rounded disabled:opacity-50">Próxima &raquo;</button>
        </div>
        
        <div class="overflow-y-auto max-h-full border border-gray-300 rounded">
          <table class="w-full min-w-full border-collapse">
            <thead>
              <tr class="bg-gray-200">
                <th v-for="cab in cabecalhos" :key="cab" class="border px-2 py-1 text-left">{{ cab }}</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="registro in registrosPaginados" :key="registro.Registro_ANS" class="border">
                <td v-for="cab in cabecalhos" :key="cab" class="border px-2 py-1">{{ registro[cab] || '-' }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>