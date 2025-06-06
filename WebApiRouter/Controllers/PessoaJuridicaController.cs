using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using WebApiRouter.Data;
using WebApiRouter.DTOs;
using WebApiRouter.Models;

namespace WebApiRouter.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PessoaJuridicaController : ControllerBase
    {
        private readonly RouterDbContext _context;

        public PessoaJuridicaController(RouterDbContext context)
        {
            _context = context;
        }

        [HttpPost]
        public async Task<ActionResult> PostPessoajuridica(PessoaJuridicaCreateDTO pessoaJuridicaDTO)
        {

            var endereco = new Endereco
            {
                Logradouro = pessoaJuridicaDTO.Endereco.Logradouro,
                Numero = pessoaJuridicaDTO.Endereco.Numero,
                Bairro = pessoaJuridicaDTO.Endereco.Bairro,
                Cidade = pessoaJuridicaDTO.Endereco.Cidade,
                Estado = pessoaJuridicaDTO.Endereco.Estado,
                Ativo = 1
            };

            _context.Enderecos.Add(endereco);
            await _context.SaveChangesAsync();

            var novaPJ = new Pessoajuridica
            {
                Nome = pessoaJuridicaDTO.Nome,
                Cnpj = pessoaJuridicaDTO.Cnpj,
                Telefone = pessoaJuridicaDTO.Telefone,
                Ativo = 1,
                Idendereco = endereco.Id,
                Codigo = await GerarCodigoPessoaJuridicaAsync()
            };

            _context.Pessoasjuridicas.Add(novaPJ);
            await _context.SaveChangesAsync();


            // Processar e salvar as PessoasFisicas e seus relacionamentos
            if (pessoaJuridicaDTO.PessoaFisica != null && pessoaJuridicaDTO.PessoaFisica.Any())
            {
                foreach (var pfDTO in pessoaJuridicaDTO.PessoaFisica)
                {
                    var novaPF = new Pessoafisica
                    {
                        Nome = pfDTO.Nome,
                        Cpf = pfDTO.Cpf,
                        Telefone = pfDTO.Telefone,
                        Ativo = 1,
                        TipopessoaId = 1,
                        Senha = null,
                        Codigo = await GerarCodigoPessoaFisicaAsync()
                    };
                    _context.Pessoasfisicas.Add(novaPF);
                    await _context.SaveChangesAsync(); // Salva a PF para obter o Id


                    // Tentar criar o relacionamento usando a propriedade de navegação
                    if (novaPJ.Pessoasfisicas == null)
                    {
                        novaPJ.Pessoasfisicas = new List<Pessoafisica>();
                    }
                    novaPJ.Pessoasfisicas.Add(novaPF); // Adiciona a PF à coleção de navegação

                }
                await _context.SaveChangesAsync(); // Salva a PJ (e os relacionamentos)

            }

            // Retornar a resposta
            return CreatedAtAction("GetPessoaJuridica", new { id = novaPJ.Id }, novaPJ);

        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<PessoaJuridicaResponseDTO>>> GetPessoajuridicas()
        {

            var pessoas = await _context.Pessoasjuridicas
                .Include(p => p.IdenderecoNavigation)
                .Include(p => p.Pessoasfisicas)
                .ToListAsync();

            var pessoaDTOs = pessoas.Select(p => new PessoaJuridicaResponseDTO
            {
                Id = p.Id,
                Nome = p.Nome,
                Cnpj = p.Cnpj,
                Telefone = p.Telefone,
                Codigo = p.Codigo,
                Ativo = p.Ativo,
                Endereco = new EnderecoResponseDTO
                {
                    Logradouro = p.IdenderecoNavigation.Logradouro,
                    Numero = p.IdenderecoNavigation.Numero,
                    Bairro = p.IdenderecoNavigation.Bairro,
                    Cidade = p.IdenderecoNavigation.Cidade,
                    Estado = p.IdenderecoNavigation.Estado
                },
                PessoaFisica = p.Pessoasfisicas.Select(pf => new PessoaFisicaResponseDTO
                {
                    Id = pf.Id,
                    Nome = pf.Nome,
                    Cpf = pf.Cpf,
                    Telefone = pf.Telefone
                }).ToList()
            });

            return Ok(pessoaDTOs);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<PessoaJuridicaResponseDTO>> GetPessoajuridica(int id)
        {

            var pessoa = await _context.Pessoasjuridicas
                          .Include(p => p.IdenderecoNavigation) // Inclui o Endereco
                          .Include(p => p.Pessoasfisicas) // Inclui as Pessoas Fisicas
                          .FirstOrDefaultAsync(p => p.Id == id);

            if (pessoa == null)
            {
                return NotFound();
            }

            var pessoaDTO = new PessoaJuridicaResponseDTO
            {
                Id = pessoa.Id,
                Nome = pessoa.Nome,
                Cnpj = pessoa.Cnpj,
                Telefone = pessoa.Telefone,
                Codigo = pessoa.Codigo,
                Endereco = new EnderecoResponseDTO
                {
                    Logradouro = pessoa.IdenderecoNavigation.Logradouro,
                    Numero = pessoa.IdenderecoNavigation.Numero,
                    Bairro = pessoa.IdenderecoNavigation.Bairro,
                    Cidade = pessoa.IdenderecoNavigation.Cidade,
                    Estado = pessoa.IdenderecoNavigation.Estado
                },
                PessoaFisica = pessoa.Pessoasfisicas.Select(pf => new PessoaFisicaResponseDTO
                {
                    Nome = pf.Nome,
                    Cpf = pf.Cpf,
                    Telefone = pf.Telefone,
                }).ToList()
            };

            return pessoaDTO;
        }

        [HttpPut("{id}")]
        public async Task<ActionResult> PutPessoajuridica(int id, Pessoajuridica pessoa)
        {
            if (id != pessoa.Id)
            {
                return BadRequest();
            }

            _context.Entry(pessoa).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!PessoajuridicaExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> DeletePessoajuridica(int id)
        {
            var pessoa = await _context.Pessoasjuridicas.FindAsync(id);
            if (pessoa == null)
            {
                return NotFound();
            }

            _context.Pessoasjuridicas.Remove(pessoa);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        [HttpPost("vincular-pfs")]
        public async Task<ActionResult> VincularMultiplasPessoasFisicas([FromBody] PessoaJuridicaVinculoMultiplosDTO dto)
        {
            if (dto.Idpfs == null || !dto.Idpfs.Any())
                return BadRequest("Lista de pessoas físicas está vazia.");

            var pessoaJuridica = await _context.Pessoasjuridicas
                .Include(pj => pj.Pessoasfisicas)
                .FirstOrDefaultAsync(pj => pj.Id == dto.Idpj);

            if (pessoaJuridica == null)
                return NotFound($"Pessoa Jurídica com ID {dto.Idpj} não encontrada.");

            var pessoasFisicas = await _context.Pessoasfisicas
                .Where(pf => dto.Idpfs.Contains(pf.Id))
                .ToListAsync();

            var idsEncontrados = pessoasFisicas.Select(pf => pf.Id).ToList();
            var idsNaoEncontrados = dto.Idpfs.Except(idsEncontrados).ToList();

            if (idsNaoEncontrados.Any())
                return NotFound($"IDs de pessoas físicas não encontrados: {string.Join(", ", idsNaoEncontrados)}");

            var idsJaVinculados = pessoaJuridica.Pessoasfisicas.Select(pf => pf.Id).ToList();

            var novosVinculos = pessoasFisicas
                .Where(pf => !idsJaVinculados.Contains(pf.Id))
                .ToList();

            if (!novosVinculos.Any())
                return Conflict("Todos os vínculos informados já existem.");

            foreach (var pf in novosVinculos)
            {
                pessoaJuridica.Pessoasfisicas.Add(pf);
            }

            await _context.SaveChangesAsync();

            return Ok($"Vínculos criados com sucesso: {novosVinculos.Count}");
        }

        [HttpDelete("{idpj}/desvincular/{idpf}")]
        public async Task<ActionResult> DesvincularPessoaFisica(int idpj, int idpf)
        {
            var pessoaJuridica = await _context.Pessoasjuridicas
                .Include(pj => pj.Pessoasfisicas)
                .FirstOrDefaultAsync(pj => pj.Id == idpj);

            if (pessoaJuridica == null)
                return NotFound($"Pessoa Jurídica com ID {idpj} não encontrada.");

            var pessoaFisica = pessoaJuridica.Pessoasfisicas.FirstOrDefault(pf => pf.Id == idpf);

            if (pessoaFisica == null)
                return NotFound($"Pessoa Física com ID {idpf} não está vinculada à PJ {idpj}.");

            pessoaJuridica.Pessoasfisicas.Remove(pessoaFisica);

            await _context.SaveChangesAsync();

            return Ok("Pessoa Física desvinculada com sucesso.");
        }

        [HttpGet("{idpj}/pessoas-fisicas")]
        public async Task<ActionResult<IEnumerable<Pessoafisica>>> GetPessoasFisicasVinculadas(int idpj)
        {
            var pessoaJuridica = await _context.Pessoasjuridicas
                .Include(pj => pj.Pessoasfisicas)
                .FirstOrDefaultAsync(pj => pj.Id == idpj);

            if (pessoaJuridica == null)
                return NotFound($"Pessoa Jurídica com ID {idpj} não encontrada.");

            return Ok(pessoaJuridica.Pessoasfisicas);
        }

        private bool PessoajuridicaExists(int id)
        {
            return _context.Pessoasjuridicas.Any(e => e.Id == id);
        }

        private async Task<string> GerarCodigoPessoaFisicaAsync()
        {
            var ano = DateTime.UtcNow.Year;

            var totalAno = await _context.Pessoasfisicas
                .Where(p => p.Codigo.StartsWith($"PF{ano}"))
                .CountAsync();

            return $"PF{ano}-{(totalAno + 1):D4}";
        }

        private async Task<string> GerarCodigoPessoaJuridicaAsync()
        {
            var ano = DateTime.UtcNow.Year;

            var totalAno = await _context.Pessoasjuridicas
                .Where(p => p.Codigo.StartsWith($"PJ{ano}"))
                .CountAsync();

            return $"PJ{ano}-{(totalAno + 1):D4}";
        }
    }
}