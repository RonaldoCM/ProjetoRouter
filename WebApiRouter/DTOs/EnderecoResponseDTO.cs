﻿namespace WebApiRouter.DTOs
{
    public class EnderecoResponseDTO
    {
        public string Logradouro { get; set; } = null!;
        public string Numero { get; set; } = null!;
        public string Bairro { get; set; } = null!;
        public string Cidade { get; set; } = null!;
        public string Estado { get; set; } = null!;
    }
}
